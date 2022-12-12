#! /usr/bin/env ruby

require 'json'
require 'open3'

preferred_ios_simulators = [
    "iPhone 14 Pro",
    "iPhone 13 Pro",
]

xcode_build_scheme="IntegrationTestRunner"

class Simulator
    attr_accessor :name, :isAvailable, :state, :udid
    def initialize simulator_dict
        @name = simulator_dict["name"]
        @isAvailable = simulator_dict["isAvailable"]
        @state = simulator_dict["state"]
        @udid = simulator_dict["udid"]
    end

    def isBooted?
        return state == "Booted"
    end
end

def find_simulator(preferred_ios_simulators)
    simulators_list = JSON.parse(`xcrun simctl list -j`)
    for os_key in simulators_list["devices"].keys do
        for simulator_dict in simulators_list["devices"][os_key] do
            simulator = Simulator.new simulator_dict
            if preferred_ios_simulators.include?(simulator.name) && simulator.isAvailable then
                return simulator
            end
        end
    end
end

begin
    simulator = find_simulator(preferred_ios_simulators)

    puts("Device id: #{simulator.udid}")

    if simulator.isBooted?
        puts("No need to boot the simulator as it is alerady booted")
    else
        puts("Booting simulator #{simulator.udid} ...")
        cmd = "xcrun simctl boot #{simulator.udid}"
        Open3.popen2(cmd) do |stdin, stdout, wait_thr|
            while line = stdout.gets
                puts line
            end
            if wait_thr.value != 0 then
                raise "Could not boot simulator. Exit code: #{wait_thr.value}"
            end
        end
        puts("Simulator #{simulator.udid} booted")
    end

    puts("Runing tests ...")
    cmd = "USE_SDK_MOCK=true flutter test integration_tests/mocked --flavor '#{xcode_build_scheme}' -d '#{simulator.udid}' -r expanded"
    Open3.popen2(cmd, chdir: "test_app") do |stdin, stdout, wait_thr|
        while line = stdout.gets
            puts line
        end
        if wait_thr.value != 0
            raise "Runnning tests has finished with exit code: #{wait_thr.value}"
        end
    end

rescue => e
    raise e
ensure
    puts("Shutting down simulator #{simulator.udid} ...")
    `xcrun simctl shutdown "#{simulator.udid}"`
    puts("Simulator #{simulator.udid} shut down")
end


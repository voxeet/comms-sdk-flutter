package io.dolby.mocks;

import java.io.IOException;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Set;

import javax.annotation.processing.AbstractProcessor;
import javax.annotation.processing.RoundEnvironment;
import javax.annotation.processing.SupportedAnnotationTypes;
import javax.lang.model.element.Element;
import javax.lang.model.element.TypeElement;
import javax.lang.model.util.ElementFilter;
import javax.tools.JavaFileObject;

@SupportedAnnotationTypes("io.dolby.mocks.Mock")
public class MockInitializer extends AbstractProcessor {
    @Override
    public boolean process(Set<? extends TypeElement> set, RoundEnvironment roundEnvironment) {
        Collection<? extends Element> annotationElement = roundEnvironment.getElementsAnnotatedWith(Mock.class);
        List<TypeElement> types = new ArrayList<>(ElementFilter.typesIn(annotationElement));
        for (TypeElement type : types) {
            processElement(type);
        }
        return false;
    }

    private void processElement(TypeElement type) {
        String className = "Auto_" + type.getSimpleName().toString();
        try {
            JavaFileObject sourceFile = processingEnv.getFiler()
                    .createSourceFile(className, type);
            Writer writer = sourceFile.openWriter();
            writer.write("");
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
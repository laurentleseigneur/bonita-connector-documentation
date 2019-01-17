import java.lang.reflect.Type

class DocProcessor {


    Properties connectorProperties

    private DocProcessor(Properties connectorProperties) {
        this.connectorProperties = connectorProperties
    }

    private static DocProcessor instance

    static newInstance(Properties properties) {
        instance = new DocProcessor(properties)
    }

    static def property(String key) {
        if (!instance.connectorProperties.containsKey(key)) {
            throw new IllegalArgumentException("property $key not found")
        }
        instance.getConnectorProperties().getProperty(key)
    }

    static def property(String key, String defaultValue) {
        if (!instance.connectorProperties.containsKey(key)) {
            return defaultValue
        }
        instance.getConnectorProperties().getProperty(key)
    }

    static def inputType(String widgetType, String inputType) {
        switch (widgetType) {
            case "definition:Select":
                return "choice"
            case "definition:Password":
                return "password"
            case "definition:Text":
            default:
                return javaType(inputType)

        }
        "$widgetType / $inputType"
    }

    static def javaType(String className) {
        Class.forName(className).getSimpleName().toLowerCase()
    }
}
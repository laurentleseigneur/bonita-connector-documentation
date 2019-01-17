
import javax.xml.transform.Templates
import javax.xml.transform.TransformerFactory
import javax.xml.transform.stream.StreamResult
import javax.xml.transform.stream.StreamSource

class ConnectorToMd {

    def connectorName
    def rootFolder

    ConnectorToMd(def rootFolder, def connectorName) {
        this.connectorName = connectorName
        this.rootFolder = rootFolder
    }

    def generateDoc() {
        def file = new File(rootFolder)
        def xmlFile = file.toPath().parent.resolve("resources").resolve("${connectorName}.def").toFile()

        def propertyFile = file.toPath().resolve("${connectorName}.properties").toFile()
        def properties = new Properties()
        propertyFile.withInputStream {
            properties.load(it)
        }

        applyXsl(xmlFile, properties)
    }

    def applyXsl(File xmlFile, Properties properties) {
        DocProcessor.newInstance(properties)

        def xslt = this.getClass().getResourceAsStream("def2Doc.xsl").text

        def factory = TransformerFactory.newInstance()
        def streamSource = new StreamSource(new StringReader(xslt))
        Templates template = factory.newTemplates(streamSource)
        def transformer = template.newTransformer()

        def xml = xmlFile.getText()
        def outputFileName = "${rootFolder}/${connectorName}.md"
        def out = new FileOutputStream(outputFileName)
        transformer.transform(new StreamSource(new StringReader(xml)), new StreamResult(out))
        new File(outputFileName).text
    }
}

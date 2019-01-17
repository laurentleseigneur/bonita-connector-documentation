import spock.lang.Specification
import spock.lang.Unroll

class ConnectorToMdTest extends Specification {

    @Unroll
    def "should parse XML file for connector #connector"(def connector) {
        given:
        ConnectorToMd connectorToMd = new ConnectorToMd("/Users/laurent/git/doc-generator/out/test/resources",connector)

        when:
        def mdContent = connectorToMd.generateDoc()

        then:
        mdContent == "*"

        where:
        connector << ['uipath-add-queueItem']

    }
}

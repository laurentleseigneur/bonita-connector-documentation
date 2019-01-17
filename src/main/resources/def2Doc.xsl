<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:definition="http://www.bonitasoft.org/ns/connector/definition/6.1"
                xmlns:java="http://xml.apache.org/xslt/java">
    <xsl:output standalone="yes" indent="no" media-type="text" omit-xml-declaration="yes"/>

    <!--variables-->
    <xsl:variable name="newLine">
        <xsl:text>&#xA;</xsl:text>
    </xsl:variable>

    <xsl:variable name="space">
        <xsl:text>&#160;</xsl:text>
    </xsl:variable>

    <xsl:variable name="pipe">
        <xsl:text>|</xsl:text>
    </xsl:variable>

    <!--root template-->
    <xsl:template match="/">
        <xsl:apply-templates select="definition:ConnectorDefinition"/>
    </xsl:template>

    <xsl:template match="definition:ConnectorDefinition">
        <xsl:call-template name="h2">
            <xsl:with-param name="content" select="java:DocProcessor.property('connectorDefinitionLabel')"/>
        </xsl:call-template>
        <xsl:call-template name="p">
            <xsl:with-param name="content" select="java:DocProcessor.property('connectorDefinitionDescription')"/>
        </xsl:call-template>
        <xsl:apply-templates select="page"/>
    </xsl:template>

    <xsl:template match="page">
        <xsl:call-template name="h3">
            <xsl:with-param name="content">
                <xsl:value-of select="java:DocProcessor.property(concat(@id,'.pageTitle'))"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="p">
            <xsl:with-param name="content">
                <xsl:value-of select="java:DocProcessor.property(concat(@id,'.pageDescription'))"/>
            </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="tableHeader"/>
        <xsl:apply-templates select="widget"/>
    </xsl:template>

    <xsl:template match="widget">
        <xsl:variable name="inputName" select="@inputName"/>
        <xsl:variable name="inputType" select="/definition:ConnectorDefinition/input[@name=$inputName]/@type"/>
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name" select="java:DocProcessor.property(concat(@id,'.label'))"/>
            <xsl:with-param name="description" select="java:DocProcessor.property(concat(@id,'.description'),$space)"/>
            <xsl:with-param name="type" select="java:DocProcessor.inputType(@xsi:type,$inputType)"/>
            <xsl:with-param name="example">
                <xsl:value-of select="java:DocProcessor.property(concat(@id,'.example'),$space)"/>
                <xsl:apply-templates select="items"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="widget[@xsi:type='definition:Array']">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name" select="@inputName"/>
            <xsl:with-param name="description">
                <xsl:apply-templates select="colsCaption"/>
            </xsl:with-param>
            <xsl:with-param name="type" select="'array'"/>
            <xsl:with-param name="example" select="java:DocProcessor.property(concat(@id,'.example'),$space)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="colsCaption">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="items">
        <xsl:value-of select="."/>
        <xsl:if test="not(position()=last())">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>

    <!--name templates-->
    <xsl:template name="h2">
        <xsl:param name="content"/>
        <xsl:value-of select="concat($newLine,'##',$space,$content,$newLine)"/>
    </xsl:template>

    <xsl:template name="h3">
        <xsl:param name="content"/>
        <xsl:value-of select="concat($newLine,'###',$space,$content,$newLine)"/>
    </xsl:template>

    <xsl:template name="p">
        <xsl:param name="content"/>
        <xsl:value-of select="concat($newLine,$content,$newLine)"/>
    </xsl:template>

    <xsl:template name="tableHeader">
        <xsl:value-of select="$newLine"/>
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name" select="'Name'"/>
            <xsl:with-param name="description" select="'Description'"/>
            <xsl:with-param name="type" select="'Type'"/>
            <xsl:with-param name="example" select="'Example'"/>
        </xsl:call-template>
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name" select="'---'"/>
            <xsl:with-param name="description" select="'---'"/>
            <xsl:with-param name="type" select="'---'"/>
            <xsl:with-param name="example" select="'---'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="tableRow">
        <xsl:param name="name"/>
        <xsl:param name="description"/>
        <xsl:param name="type"/>
        <xsl:param name="example"/>
        <xsl:value-of
                select="concat($newLine,$pipe,$name,$pipe,$description,$pipe,$type,$pipe,$example,$pipe)"/>
    </xsl:template>


</xsl:stylesheet>
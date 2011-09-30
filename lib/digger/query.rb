module Digger

  # Contains queries for the DIG reasoner.
  module Query

    NSS = <<HERE
xmlns="#{Digger::NS}"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
xmlns:owl="http://www.w3.org/2002/07/owl#"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://dl.kr.org/dig/2003/02/lang http://dl-web.man.ac.uk/dig/2003/02/dig.xsd"
HERE

    GET_IDENTIFIER = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<getIdentifier #{NSS} />
HERE

    NEW_KB = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<newKB #{NSS} />
HERE

    RELEASE_KB = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<releaseKB #{NSS} uri="%s" />
HERE

    ASK_ALLCONCEPTNAMES = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<asks uri="%s"><allConceptNames id="acn"/></asks>
HERE

    ASK_ALLROLENAMES = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <allRoleNames id="arn"/>
  </asks>
</xsl:template>
</xsl:stylesheet>
HERE

    ASK_ALLINDIVIDUALS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <allIndividuals id="ai"/>
  </asks>
</xsl:template>
</xsl:stylesheet>
HERE

    # Satisfiability

    ASK_SATISFIABLE = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <satisfiable><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </satisfiable>
</xsl:template>

</xsl:stylesheet>
HERE


    # Concept Hierarchy

    ASK_PARENTS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]"/>
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <parents><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </parents>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_CHILDREN = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]"/>
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <children><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </children>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_DESCENDANTS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]"/>
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <descendants><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </descendants>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_ANCESTORS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]"/>
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <ancestors><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </ancestors>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_EQUIVALENTS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <equivalents><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </equivalents>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_RPARENTS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#ObjectProperty')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="rolename" select="../@rdf:about"/>
  <rparents><xsl:attribute name="id"><xsl:value-of select="$rolename"/></xsl:attribute>
  <ratom><xsl:attribute name="name"><xsl:value-of select="$rolename" /></xsl:attribute>
  </ratom>
  </rparents>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_RCHILDREN = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#ObjectProperty')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="rolename" select="../@rdf:about"/>
  <rchildren><xsl:attribute name="id"><xsl:value-of select="$rolename"/></xsl:attribute>
  <ratom><xsl:attribute name="name"><xsl:value-of select="$rolename" /></xsl:attribute>
  </ratom>
  </rchildren>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_RANCESTORS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#ObjectProperty')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="rolename" select="../@rdf:about"/>
  <rancestors><xsl:attribute name="id"><xsl:value-of select="$rolename"/></xsl:attribute>
  <ratom><xsl:attribute name="name"><xsl:value-of select="$rolename" /></xsl:attribute>
  </ratom>
  </rancestors>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_RDESCENDANTS = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#ObjectProperty')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="rolename" select="../@rdf:about"/>
  <rdescendants><xsl:attribute name="id"><xsl:value-of select="$rolename"/></xsl:attribute>
  <ratom><xsl:attribute name="name"><xsl:value-of select="$rolename" /></xsl:attribute>
  </ratom>
  </rdescendants>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_INSTANCES = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type[contains(@rdf:resource,'#Class')]" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="classname" select="../@rdf:about"/>
  <instances><xsl:attribute name="id"><xsl:value-of select="$classname"/></xsl:attribute>
  <catom><xsl:attribute name="name"><xsl:value-of select="$classname" /></xsl:attribute>
  </catom>
  </instances>
</xsl:template>

</xsl:stylesheet>
HERE

    ASK_TYPES = <<HERE
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" #{NSS}>
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <asks uri="{$param}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type" />
  </asks>
</xsl:template>

<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="instancename" select="../@rdf:about"/>

  <xsl:choose>
  <!-- Class definition -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#Class")'/>
  <!-- Property definition -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#ObjectProperty")'/>
  <!-- property is transitive -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#TransitiveProperty")'/>
  <!-- property is functional -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#InverseFunctionalProperty")'/>
  <!-- property is functional -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#FunctionalProperty")'/>
  <!-- Restrictions: existence quantor -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#Restriction")'/>
  <xsl:when test='@rdf:resource=""'/>
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#Ontology")'/>

  <!-- INDIVIDUAL -->
  <xsl:otherwise>
    <types>
      <xsl:attribute name="id"><xsl:value-of select="$instancename"/></xsl:attribute>
      <individual>
        <xsl:attribute name="name"><xsl:value-of select="$instancename"/></xsl:attribute>
      </individual>
    </types>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
HERE

    # Query building module,
    # contains methods to build queries or query parts.
    module Builder

      def self.someValuesFrom(class_uri, property_uri)
        "<some><ratom name='#{property_uri}'/><catom name='#{class_uri}'/></some>"
      end

      def self.allValuesFrom(class_uri, property_uri)
        "<all><ratom name='#{property_uri}'/><catom name='#{class_uri}'/></all>"
      end

    end

  end

end

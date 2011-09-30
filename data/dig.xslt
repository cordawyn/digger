<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:ns0="NAMESPACE_FOR_YOUR_ONTOLOGY#"
    xmlns="http://dl.kr.org/dig/2003/03/lang">
<xsl:output method="xml" encoding="UTF-8" version="1.0" />

<xsl:template match="/">
  <tells uri="{$kb_uuid}">
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdf:type"/>
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdfs:subClassOf"/>
  <xsl:apply-templates select="rdf:RDF/rdf:Description/owl:disjointWith"/>
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdfs:subPropertyOf"/>
  <xsl:apply-templates select="rdf:RDF/rdf:Description/owl:inverseOf"/>
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdfs:domain"/>
  <xsl:apply-templates select="rdf:RDF/rdf:Description/rdfs:range"/>
  </tells>
</xsl:template>

<!-- class and property defintion -->
<xsl:template match="rdf:Description/rdf:type">
  <xsl:variable name="itemname" select="../@rdf:about"/>
  
  <xsl:choose>
  <!-- Class definition -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#Class")'>
    <defconcept><xsl:attribute name="name"><xsl:value-of select="$itemname" /></xsl:attribute>
    </defconcept>
  </xsl:when>
  <!-- Property definition -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#ObjectProperty")'>
    <defrole><xsl:attribute name="name"><xsl:value-of select="$itemname" /></xsl:attribute>
    </defrole>
  </xsl:when>
  <!-- property is transitive -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#TransitiveProperty")'>
    <transitive>
      <ratom><xsl:attribute name="name"><xsl:value-of select="$itemname"/></xsl:attribute>
      </ratom>
    </transitive>
  </xsl:when>
  <!-- property is functional -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#InverseFunctionalProperty")'>
    <functional>
      <ratom><xsl:attribute name="name"><xsl:value-of select="$itemname"/></xsl:attribute>
      </ratom>
    </functional>
  </xsl:when>
  <!-- property is functional -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#FunctionalProperty")'>
    <functional>
      <ratom><xsl:attribute name="name"><xsl:value-of select="$itemname"/></xsl:attribute>
      </ratom>
    </functional>
  </xsl:when>
  <!-- Restrictions: existence quantor -->
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#Restriction")'>
    <xsl:variable name="node" select="../@rdf:nodeID"/>
    
    <xsl:if test='/rdf:RDF/rdf:Description/rdfs:subClassOf/@rdf:nodeID=$node'>
    <!-- NECESSARY CONDITION -->
      <impliesc>
      <xsl:for-each select='/rdf:RDF/rdf:Description/rdfs:subClassOf[@rdf:nodeID=$node]'>
        <catom><xsl:attribute name="name"><xsl:value-of select="../@rdf:about"/></xsl:attribute>
        </catom>
      </xsl:for-each>
      <some>
        <xsl:if test='/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:onProperty/@rdf:resource!=""'>
          <ratom><xsl:attribute name="name"><xsl:value-of select="/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:onProperty/@rdf:resource"/></xsl:attribute>
          </ratom>
        </xsl:if>

        <xsl:if test='/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:someValuesFrom/@rdf:resource!=""'>
          <catom><xsl:attribute name="name"><xsl:value-of select="/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:someValuesFrom/@rdf:resource"/></xsl:attribute>
          </catom>
        </xsl:if>
      </some>
      </impliesc>
    </xsl:if>
    
    <xsl:if test='/rdf:RDF/rdf:Description/owl:equivalentClass/@rdf:nodeID=$node'>
    <!-- NECESSARY & SUFFICIENT CONDITION -->
      <equalc>
      <xsl:for-each select='/rdf:RDF/rdf:Description/owl:equivalentClass[@rdf:nodeID=$node]'>
        <catom><xsl:attribute name="name"><xsl:value-of select="../@rdf:about"/></xsl:attribute>
        </catom>
      </xsl:for-each>
      <and><some>
        <xsl:if test='/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:onProperty/@rdf:resource!=""'>
          <ratom><xsl:attribute name="name"><xsl:value-of select="/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:onProperty/@rdf:resource"/></xsl:attribute>
          </ratom>
        </xsl:if>

        <xsl:if test='/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:someValuesFrom/@rdf:resource!=""'>
          <catom><xsl:attribute name="name"><xsl:value-of select="/rdf:RDF/rdf:Description[@rdf:nodeID=$node]/owl:someValuesFrom/@rdf:resource"/></xsl:attribute>
          </catom>
        </xsl:if>
      </some> </and>
      </equalc>
    </xsl:if>
  </xsl:when>
  
  <xsl:when test='@rdf:resource=""'/>
  <xsl:when test='@rdf:resource!="" and contains(@rdf:resource,"#Ontology")'/>
  
  <!-- INDIVIDUAL -->
  <xsl:otherwise>
    <defindividual> <xsl:attribute name="name"><xsl:value-of select="$itemname"/></xsl:attribute>
    </defindividual>
    <instanceof> 
      <individual> <xsl:attribute name="name"><xsl:value-of select="$itemname"/></xsl:attribute>
      </individual>
      <catom><xsl:attribute name="name"><xsl:value-of select="@rdf:resource"/></xsl:attribute>
      </catom>
    </instanceof>
    
    <xsl:for-each select='/rdf:RDF/rdf:Description[contains(@rdf:about, $itemname)]/ns0:*'>
    
    <related>
      <individual> <xsl:attribute name="name"><xsl:value-of select="$itemname"/></xsl:attribute>
      </individual>
      <ratom> <xsl:attribute name="name"><xsl:value-of select="namespace-uri()"/><xsl:value-of select="local-name()"/></xsl:attribute>
      </ratom>
      <individual> <xsl:attribute name="name"><xsl:value-of select="@rdf:resource"/></xsl:attribute>
      </individual>
    </related>    
    </xsl:for-each>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- definition: class1 is subclass of class2: necessary condition -->
<xsl:template match="rdf:Description/rdfs:subClassOf">
  <xsl:variable name="class1" select="../@rdf:about"/>
  <xsl:variable name="class2" select="@rdf:resource"/>
  
  <xsl:if test='$class2!=""'>
    <impliesc>
      <catom><xsl:attribute name="name"><xsl:value-of select="$class1"/></xsl:attribute>
      </catom>
      <catom><xsl:attribute name="name"><xsl:value-of select="$class2"/></xsl:attribute>
      </catom>
    </impliesc>
  </xsl:if>
</xsl:template>

<!-- definition: disjoint item1 and item2 -->
<xsl:template match="rdf:Description/owl:disjointWith">
  <xsl:variable name="item1" select="../@rdf:about"/>
  <xsl:variable name="item2" select="@rdf:resource"/>
  <disjoint>
    <catom><xsl:attribute name="name"><xsl:value-of select="$item1"/></xsl:attribute>
    </catom>
    <catom><xsl:attribute name="name"><xsl:value-of select="$item2"/></xsl:attribute>
    </catom>
  </disjoint>
</xsl:template>

<!-- definition: property1 is subproperty of property2 -->
<xsl:template match="rdf:Description/rdfs:subPropertyOf">
  <xsl:variable name="property1" select="../@rdf:about"/>
  <xsl:variable name="property2" select="@rdf:resource"/>
  <impliesr>
    <ratom><xsl:attribute name="name"><xsl:value-of select="$property1"/></xsl:attribute>
    </ratom>
    <ratom><xsl:attribute name="name"><xsl:value-of select="$property2"/></xsl:attribute>
    </ratom>
  </impliesr>
</xsl:template>

<!-- definition: property1 is inverseOf property2 -->
<xsl:template match="rdf:Description/owl:inverseOf">
  <xsl:variable name="property1" select="../@rdf:about"/>
  <xsl:variable name="property2" select="@rdf:resource"/>
  <equalr>
    <ratom><xsl:attribute name="name"><xsl:value-of select="$property1"/></xsl:attribute>
    </ratom>
    <inverse><ratom><xsl:attribute name="name"><xsl:value-of select="$property2"/></xsl:attribute>
    </ratom></inverse>
  </equalr>
</xsl:template>

<!-- definition: property is in domain of class -->
<xsl:template match="rdf:Description/rdfs:domain">
  <xsl:variable name="property" select="../@rdf:about"/>
  <xsl:variable name="class" select="@rdf:resource"/>
  <domain>
    <ratom><xsl:attribute name="name"><xsl:value-of select="$property"/></xsl:attribute>
    </ratom>
    <catom><xsl:attribute name="name"><xsl:value-of select="$class"/></xsl:attribute>
    </catom>
  </domain>
</xsl:template>

<!-- definition: class is in range of property -->
<xsl:template match="rdf:Description/rdfs:range">
  <xsl:variable name="property" select="../@rdf:about"/>
  <xsl:variable name="class" select="@rdf:resource"/>
  <range>
    <ratom><xsl:attribute name="name"><xsl:value-of select="$property"/></xsl:attribute>
    </ratom>
    <or><catom><xsl:attribute name="name"><xsl:value-of select="$class"/></xsl:attribute>
    </catom></or>
  </range>
</xsl:template>

</xsl:stylesheet>

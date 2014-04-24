<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:serviceNs="http://www.spacebel.be/sse" 
	xmlns:ogc="http://www.opengis.net/ogc">
	<xsl:import href="./icd/ogc-13-084r1/ogc-13-084r1-v10-csw-v202-catalogue.xsl"/>
	<!-- Parameter used to specify which part of this style sheet will be applied -->
	<xsl:param name="part"/>
	<!-- Template application -->
	<!-- Switch for the different parts -->
	<xsl:template match="/*">
		<xsl:variable name="useWorkflow">
		</xsl:variable>
		<xsl:choose>
		<!-- *********************************************************
		             Present
		      ********************************************************* -->
		<!-- Used for service's Search presentation and processing -->		    
			<xsl:when test="$part='processPresentInputXML'">
				<xsl:choose>
					 <xsl:when test="normalize-space($useWorkflow)='yes'">
						<serviceNs:processPresentInputMsg>
							<xsl:apply-templates select="serviceNs:sendPresentInput" mode="XML"/>
						</serviceNs:processPresentInputMsg>
					</xsl:when>
					<xsl:otherwise>
 						<URL>?request=GetRepositoryItem&amp;service=CSW&amp;version=2.0.2&amp;Id=<xsl:value-of select="serviceNs:sendPresentInput/productId"/></URL>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:when>
            <xsl:when test="$part='getPresentOutputHTML'">
			    <xsl:call-template name="generatePresentOutput"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

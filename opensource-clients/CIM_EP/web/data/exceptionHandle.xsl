<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:ows="http://www.opengis.net/ows/2.0"
	xmlns:serviceNs="http://www.spacebel.be/sse">

	<xsl:template match="serviceNs:error">
		<elements numberOfRecordsReturned="0" startPosition="1"
			numberOfRecordsMatched="0" nextRecord="1" maxRecordsMatched="0"
			collectionHasData="1" numOfRecordMatchFromCatReturnNoData="1" displayedRecords="1">
			<error>
				<errorCode><xsl:value-of select="./serviceNs:errorCode"/></errorCode>
				<xsl:choose>
					<xsl:when test="./serviceNs:errorMsg/ows:ExceptionReport/ows:Exception/ows:ExceptionText">
						<errorMsg>Error: <xsl:value-of select="./serviceNs:errorMsg/ows:ExceptionReport/ows:Exception/ows:ExceptionText"/></errorMsg>
					</xsl:when>		
					<xsl:otherwise>	
						<errorMsg>Error while processing the operation.</errorMsg>
					</xsl:otherwise>
				</xsl:choose>					
			</error>
		</elements>		
	</xsl:template>
</xsl:stylesheet>
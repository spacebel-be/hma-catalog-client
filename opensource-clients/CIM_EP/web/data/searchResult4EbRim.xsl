<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:sse="http://www.esa.int/mass"
	xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
	xmlns:ows="http://www.opengis.net/ows"
	xmlns:serviceNs="http://www.spacebel.be/sse">
	<!-- Import statements -->
	<xsl:import href="./xslFunctions.xsl"/>
	<xsl:param name="displayFilter"/>
	
	<!-- Default HTML template of the getSearchOutput node. -->
	<xsl:template name="generateSearchOutput">
		<xsl:param name="displayedRecords" />		
		<xsl:choose>
			<!-- Response comes directly from remote catalogue  -->
			<xsl:when test="contains(name(),'GetRecordsResponse')">	
				<xsl:variable name="numberOfRecordsReturned" select="//@numberOfRecordsReturned" />
				<xsl:variable name="numberOfRecordsMatched" select="//@numberOfRecordsMatched" />
				<xsl:variable name="maxRecordsMatched" select="//@numberOfRecordsMatched" />
				<xsl:variable name="collectionHasData" select="'1'" />
				<xsl:variable name="numOfRecordMatchFromCatReturnNoData" select="'0'" />
				<xsl:variable name="nextRecord">
					<xsl:choose>
						<xsl:when test="//@nextRecord">	
							<xsl:value-of select="//@nextRecord" />
						</xsl:when>		
						<xsl:otherwise>	
							<xsl:value-of select="//@numberOfRecordsReturned + 1" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="startPosition">
					<xsl:choose>
						<xsl:when test="$nextRecord > 0">	
							<xsl:value-of select="$nextRecord - $numberOfRecordsReturned" />
						</xsl:when>		
						<xsl:otherwise>	
							<xsl:value-of select="$numberOfRecordsMatched - $numberOfRecordsReturned + 1" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>	
				<xsl:choose>
					<xsl:when test="$startPosition > 0">	
						<elements numberOfRecordsReturned="{$numberOfRecordsReturned}" startPosition="{$startPosition}"
							numberOfRecordsMatched="{$numberOfRecordsMatched}" nextRecord="{$nextRecord}" maxRecordsMatched="{$numberOfRecordsMatched}"
							collectionHasData="{$collectionHasData}" numOfRecordMatchFromCatReturnNoData="{$numOfRecordMatchFromCatReturnNoData}" displayedRecords="{$displayedRecords}">			
							<xsl:if test="//csw:SearchStatus !=''">
								<error>
									<errorCode>300</errorCode>
									<errorMsg><xsl:value-of select="//csw:SearchStatus"/></errorMsg>
								</error>
							</xsl:if>
							<xsl:for-each select="*">
								<xsl:apply-templates select=".">
									<xsl:with-param name="displayedRecords"> 
										<xsl:value-of select="$displayedRecords" />
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:for-each>		
						</elements>
					</xsl:when>		
					<xsl:otherwise>	
						<elements numberOfRecordsReturned="{$numberOfRecordsReturned}" startPosition="1"
							numberOfRecordsMatched="{$numberOfRecordsMatched}" nextRecord="{$nextRecord}" maxRecordsMatched="{$maxRecordsMatched}"
							collectionHasData="{$collectionHasData}" numOfRecordMatchFromCatReturnNoData="{$numOfRecordMatchFromCatReturnNoData}" displayedRecords="{$displayedRecords}">			
							<xsl:if test="//csw:SearchStatus !=''">
								<error>
									<errorCode>300</errorCode>
									<errorMsg><xsl:value-of select="//csw:SearchStatus"/></errorMsg>
								</error>
							</xsl:if>
							<xsl:for-each select="*">
								<xsl:apply-templates select=".">
									<xsl:with-param name="displayedRecords"> 
										<xsl:value-of select="$displayedRecords" />
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:for-each>		
						</elements>	
					</xsl:otherwise>
				</xsl:choose>					
			</xsl:when>
			<xsl:when test="contains(name(),'Fault')">					
				<elements numberOfRecordsReturned="0" startPosition="1"
					numberOfRecordsMatched="0" nextRecord="1" maxRecordsMatched="0"
					collectionHasData="1" numOfRecordMatchFromCatReturnNoData="1" displayedRecords="1">
					<error>
						<xsl:choose>
							<xsl:when test="//detail/ows:ExceptionReport">
								<errorCode>300</errorCode>
								<errorMsg>							
									<xsl:value-of select="//detail/ows:ExceptionReport/ows:Exception/@exceptionCode"/>:
									<xsl:value-of select="//detail/ows:ExceptionReport/ows:Exception/ows:ExceptionText"/>
								</errorMsg>
							</xsl:when>
							<xsl:otherwise>	
								<errorCode><xsl:value-of select="//faultcode"/></errorCode>
								<errorMsg>
									<xsl:value-of select="//faultstring"/>							
								</errorMsg>
							</xsl:otherwise>	
						</xsl:choose>
					</error>
				</elements>
			</xsl:when>
			<!-- Response comes from workflow -->
			<xsl:otherwise>							
				<xsl:variable name="numberOfRecordsReturned" select="//serviceNs:numberOfRecordsReturned" />
				<xsl:variable name="numberOfRecordsMatched" select="//serviceNs:numberOfRecordsMatched" />
				<xsl:variable name="nextRecord" select="//serviceNs:nextRecord" />
				<xsl:variable name="maxRecordsMatched" select="//serviceNs:maxRecordsMatched" />
				<xsl:variable name="collectionHasData" select="//serviceNs:collectionHasData" />
				<xsl:variable name="numOfRecordMatchFromCatReturnNoData" select="//serviceNs:numOfRecordMatchFromCatReturnNoData" />
				<!--
				<xsl:variable name="startPosition" select="//serviceNs:startPosition" />
				-->
				<xsl:variable name="startPosition">
					<xsl:choose>
						<xsl:when test="$nextRecord > 0">	
							<xsl:value-of select="$nextRecord - $numberOfRecordsReturned" />
						</xsl:when>		
						<xsl:otherwise>	
							<xsl:value-of select="$numberOfRecordsMatched - $numberOfRecordsReturned + 1" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>					
				<elements numberOfRecordsReturned="{$numberOfRecordsReturned}" startPosition="{$startPosition}"
					numberOfRecordsMatched="{$numberOfRecordsMatched}" nextRecord="{$nextRecord}" maxRecordsMatched="{$numberOfRecordsMatched}"
					collectionHasData="{$collectionHasData}" numOfRecordMatchFromCatReturnNoData="{$numOfRecordMatchFromCatReturnNoData}" displayedRecords="{$displayedRecords}">
					<xsl:choose>
						<xsl:when test="normalize-space(sse:statusInfo/sse:statusId) = '300'">				
							<error>
								<errorCode><xsl:value-of select="sse:statusInfo/sse:statusId"/></errorCode>
								<errorMsg><xsl:value-of select="sse:statusInfo/sse:statusMsg"/></errorMsg>
							</error>						
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="*">
								<xsl:apply-templates select=".">
									<xsl:with-param name="displayedRecords"> 
										<xsl:value-of select="$displayedRecords" />
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:for-each>					
						</xsl:otherwise>
					</xsl:choose>
				</elements>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--
		***************************************************************************
		Templates used to generate Present output HTML
		***************************************************************************
		!
	-->
	<!-- Default HTML template of the getSearchOutput node. -->
	<xsl:template name="generatePresentOutput">	
		<xsl:choose>
			<!-- Response comes directly from remote catalogue, for EOP  -->
			<xsl:when test="contains(name(),'GetRecordByIdResponse')">	
				<elements>
					<xsl:for-each select="*">
						<xsl:apply-templates select="." />
					</xsl:for-each>
				</elements>
			</xsl:when>
			<!-- Response comes directly from remote catalogue, for CIM  -->
			<xsl:when test="contains(name(),'Metadata')">	
				<elements>
					<xsl:call-template name="serviceNs:portalMetadataFull">
						<xsl:with-param name="self" select="."/>
					</xsl:call-template>
				</elements>
			</xsl:when>
			<!-- Response comes directly from remote catalogue, for Sensor  -->
			<xsl:when test="contains(name(),'SensorML')">	
				<elements>
					<xsl:call-template name="serviceNs:portalMetadataFull">
						<xsl:with-param name="self" select="."/>
					</xsl:call-template>
				</elements>
			</xsl:when>
			<!-- Response comes from workflow -->
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="sse:statusInfo/sse:statusId='0'">
						<elements>
							<xsl:for-each select="*">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</elements>
					</xsl:when>
					<xsl:otherwise>
						<elements>
							<error>
									<errorCode><xsl:value-of select="//sse:statusInfo/sse:statusId"/></errorCode>
									<errorMsg><xsl:value-of select="//sse:statusInfo/sse:statusMsg"/></errorMsg>
							</error>
						</elements>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<xsl:template match="sse:statusInfo" />
</xsl:stylesheet>

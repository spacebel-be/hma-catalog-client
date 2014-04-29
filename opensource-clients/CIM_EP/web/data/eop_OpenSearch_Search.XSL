<xsl:stylesheet version="1.0" xmlns:mass="http://www.esa.int/mass"
	xmlns:sse="http://www.esa.int/mass"
	xmlns:serviceNS="http://www.spacebel.be/sse"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oi="http://www.esa.int/oi"
	xmlns:aoi="http://www.esa.int/xml/schemas/mass/aoifeatures"	
	xmlns:ows="http://www.opengis.net/ows/2.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:gml32="http://www.opengis.net/gml/3.2"
	xmlns:om="http://www.opengis.net/om/2.0"
	xmlns:eop="http://www.opengis.net/eop/2.1"
	xmlns:opt="http://www.opengis.net/opt/2.1"
	xmlns:sar="http://www.opengis.net/sar/2.1"
	xmlns:atm="http://www.opengis.net/atm/2.1"
	xmlns:gmi="http://www.isotc211.org/2005/gmi"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:georss="http://www.georss.org/georss"
	xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"	
	xmlns:atom="http://www.w3.org/2005/Atom"
	xmlns:os="http://a9.com/-/spec/opensearch/1.1/">
	<xsl:import href="./exceptionHandle.xsl"/>
	<xsl:param name="part" />	
	<xsl:template match="/*">
		<xsl:choose>
			<!-- *********************************************************
				Search
				********************************************************* -->
			<!-- Used for service's Search presentation and processing -->
			<xsl:when test="$part='sendSearchInputHTML'">
				<xsl:apply-templates select="mass:sendSearchInput"/>
			</xsl:when>
			<xsl:when test="$part='processSearchInputXML'">
				<xsl:apply-templates
					select="serviceNS:sendSearchInput" mode="XML" />
			</xsl:when>
			<xsl:when test="$part='getSearchOutputHTML'">
				<xsl:choose>
					<xsl:when test="serviceNS:error">
						<xsl:apply-templates select="serviceNS:error"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="atom:feed"/>
					</xsl:otherwise>
				</xsl:choose>				
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>
	<!-- ***************************************************************************
		Templates used to display Search input information using XML format
		*************************************************************************** !-->		
	<xsl:template match="mass:sendSearchInput">
		<inputSearchDefaults xmlns="http://www.spacebel.be/jsf/interface/search">			
			<input type="date" name="used_time_start" format="yyyy-MM-dd" />
			<input type="date" name="used_time_end" format="yyyy-MM-dd" />
			<input type="string" name="used_eo_parentIdentifier" />
			<input type="string" name="used_geo_uid" />
			<input type="string" name="used_geo_name" />
			<input type="string" name="used_geo_radius" />			
			<input type="string" name="used_searchTerms" />
			<input type="string" name="used_eo_platformShortName" />
			<input type="string" name="used_eo_platformSerialIdentifier" />
			<input type="string" name="used_eo_instrument" />			
			<input type="string" name="iteratorSize" value="10" />			
		</inputSearchDefaults>		
	</xsl:template>
	<!-- ***************************************************************************
		Templates used to generate Search input information using XML format
		*************************************************************************** !-->
	<xsl:template match="serviceNS:sendSearchInput" mode="XML">
		<xsl:variable name="startDateTime">
			<xsl:if test="used_time_start != ''">
				<xsl:value-of select="used_time_start"/>T00:00:00Z
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="endDateTime">
			<xsl:if test="used_time_end != ''">
				<xsl:value-of select="used_time_end"/>T10:00:59Z
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="timePosition">
			<xsl:if test="used_time_timePosition != ''">
				<xsl:value-of select="used_time_timePosition"/>T10:00:59Z
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="eoProcessingDate">
			<xsl:if test="used_eo_processingDate != ''">
				<xsl:value-of select="used_eo_processingDate"/>T10:00:59Z
			</xsl:if>
		</xsl:variable>
		
		<opensearchParameters>		
			<xsl:if test="used_iteratorSize != ''">
				<count><xsl:value-of select="used_iteratorSize"/></count>
			</xsl:if>
			<xsl:if test="used_cursor != ''">
				<startIndex><xsl:value-of select="used_cursor"/></startIndex>
			</xsl:if>
			<xsl:if test="used_eo_parentIdentifier != ''">
				<eo_parentIdentifier><xsl:value-of select="used_eo_parentIdentifier"/></eo_parentIdentifier>
			</xsl:if>
			<xsl:if test="normalize-space($startDateTime) != ''">
				<time_start><xsl:value-of select="normalize-space($startDateTime)"/></time_start>
			</xsl:if>
			<xsl:if test="normalize-space($endDateTime) != ''">
				<time_end><xsl:value-of select="normalize-space($endDateTime)"/></time_end>
			</xsl:if>
			<!-- OGC 10-032 Table 4- Search operation queryable mappings  -->
			<xsl:if test="used_searchTerms != ''">
				<searchTerms><xsl:value-of select="used_searchTerms"/></searchTerms>
			</xsl:if>
			<xsl:if test="used_geo_uid != ''">
				<geo_uid><xsl:value-of select="used_geo_uid"/></geo_uid>
			</xsl:if>			
			<xsl:if test="used_geo_lat != ''">
				<geo_lat><xsl:value-of select="used_geo_lat"/></geo_lat>
			</xsl:if>
			<xsl:if test="used_geo_lon != ''">
				<geo_lon><xsl:value-of select="used_geo_lon"/></geo_lon>
			</xsl:if>
			<xsl:if test="used_geo_name != ''">
				<geo_name><xsl:value-of select="used_geo_name"/></geo_name>
			</xsl:if>
			<xsl:if test="used_geo_radius != ''">
				<geo_radius><xsl:value-of select="used_geo_radius"/></geo_radius>
			</xsl:if>
			<xsl:if test="used_geo_relation != ''">
				<geo_relation><xsl:value-of select="used_geo_relation"/></geo_relation>
			</xsl:if>
			<xsl:if test="normalize-space($timePosition) != ''">
				<time_timePosition><xsl:value-of select="normalize-space($timePosition)"/></time_timePosition>
			</xsl:if>
			<xsl:if test="used_time_relation != ''">
				<time_relation><xsl:value-of select="used_time_relation"/></time_relation>
			</xsl:if>
			<xsl:if test="used_language != ''">
				<language><xsl:value-of select="used_language"/></language>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope/gml:lowerCorner != ''">
					<xsl:variable name="a" select="substring-before(//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope/gml:lowerCorner, ' ')"/>
					<xsl:variable name="b" select="substring-after(//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope/gml:lowerCorner, ' ')"/>
					<xsl:variable name="c" select="substring-before(//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope/gml:upperCorner, ' ')"/>
					<xsl:variable name="d" select="substring-after(//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope/gml:upperCorner, ' ')"/>
					<xsl:variable name="space" select="','"/>
					<geo_box><xsl:value-of select="$b"/><xsl:value-of select="$space"/><xsl:value-of select="$a"/><xsl:value-of select="$space"/><xsl:value-of select="$d"/><xsl:value-of select="$space"/><xsl:value-of select="$c"/></geo_box>
				</xsl:when>
			</xsl:choose>
			<!-- OGC 13-026 Table 3 - OpenSearch Parameters for Collection Search -->			
			<xsl:if test="used_eo_productType != ''">
				<eo_productType><xsl:value-of select="used_eo_productType"/></eo_productType>
			</xsl:if>			
			<xsl:if test="used_eo_platformShortName != ''">
				<eo_platformShortName><xsl:value-of select="used_eo_platformShortName"/></eo_platformShortName>
			</xsl:if>
			<xsl:if test="used_eo_platformSerialIdentifier != ''">
				<eo_platformSerialIdentifier><xsl:value-of select="used_eo_platformSerialIdentifier"/></eo_platformSerialIdentifier>
			</xsl:if>			
			<xsl:if test="used_eo_instrument != ''">
				<eo_instrument><xsl:value-of select="used_eo_instrument"/></eo_instrument>
			</xsl:if>
			<xsl:if test="used_eo_sensorType!= ''">
				<eo_sensorType><xsl:value-of select="used_eo_sensorType"/></eo_sensorType>
			</xsl:if>
			<xsl:if test="used_eo_compositeType!= ''">
				<eo_compositeType><xsl:value-of select="used_eo_compositeType"/></eo_compositeType>
			</xsl:if>
			<xsl:if test="used_eo_processingLevel!= ''">
				<eo_processingLevel><xsl:value-of select="used_eo_processingLevel"/></eo_processingLevel>
			</xsl:if>
			<xsl:if test="used_eo_orbitType != ''">
				<eo_orbitType><xsl:value-of select="used_eo_orbitType"/></eo_orbitType>
			</xsl:if>
			<xsl:if test="used_eo_resolution != ''">
				<eo_resolution><xsl:value-of select="used_eo_resolution"/></eo_resolution>
			</xsl:if>
			<xsl:if test="used_eo_spectralRange != ''">
				<eo_spectralRange><xsl:value-of select="used_eo_spectralRange"/></eo_spectralRange>
			</xsl:if>
			<xsl:if test="used_eo_wavelengths != ''">
				<eo_wavelengths><xsl:value-of select="used_eo_wavelengths"/></eo_wavelengths>
			</xsl:if>
			<xsl:if test="used_eo_useLimitation != ''">
				<eo_useLimitation><xsl:value-of select="used_eo_useLimitation"/></eo_useLimitation>
			</xsl:if>
			<xsl:if test="used_eo_hasSecurityConstraints != ''">
				<eo_hasSecurityConstraints><xsl:value-of select="used_eo_hasSecurityConstraints"/></eo_hasSecurityConstraints>
			</xsl:if>
			<xsl:if test="used_eo_organizationName != ''">
				<eo_organizationName><xsl:value-of select="used_eo_organizationName"/></eo_organizationName>
			</xsl:if>
			<xsl:if test="used_eo_dissemination != ''">
				<eo_dissemination><xsl:value-of select="used_eo_dissemination"/></eo_dissemination>
			</xsl:if>
			<!-- OGC 13-026 Table 4 - OpenSearch Parameters for Product Search -->
			<xsl:if test="used_eo_productionStatus!= ''">
				<eo_productionStatus><xsl:value-of select="used_eo_productionStatus"/></eo_productionStatus>
			</xsl:if>
			<xsl:if test="used_eo_acquisitionType!= ''">
				<eo_acquisitionType><xsl:value-of select="used_eo_acquisitionType"/></eo_acquisitionType>
			</xsl:if>
			<xsl:if test="used_eo_orbitNumber != ''">
				<eo_orbitNumber><xsl:value-of select="used_eo_orbitNumber"/></eo_orbitNumber>
			</xsl:if>
			<xsl:if test="used_eo_orbitDirection != ''">
				<eo_orbitDirection><xsl:value-of select="used_eo_orbitDirection"/></eo_orbitDirection>
			</xsl:if>
			<xsl:if test="used_eo_track != ''">
				<eo_track><xsl:value-of select="used_eo_track"/></eo_track>
			</xsl:if>
			<xsl:if test="used_eo_frame != ''">
				<eo_frame><xsl:value-of select="used_eo_frame"/></eo_frame>
			</xsl:if>
			<xsl:if test="used_eo_swathIdentifier != ''">
				<eo_swathIdentifier><xsl:value-of select="used_eo_swathIdentifier"/></eo_swathIdentifier>
			</xsl:if>
			<xsl:if test="used_eo_cloudCover!= ''">
				<eo_cloudCover><xsl:value-of select="used_eo_cloudCover"/></eo_cloudCover>
			</xsl:if>
			<xsl:if test="used_eo_snowCover!= ''">
				<eo_snowCover><xsl:value-of select="used_eo_snowCover"/></eo_snowCover>
			</xsl:if>
			<xsl:if test="used_eo_imageQualityDegradation != ''">
				<eo_imageQualityDegradation><xsl:value-of select="used_eo_imageQualityDegradation"/></eo_imageQualityDegradation>
			</xsl:if>			
			<xsl:if test="used_eo_imageQualityDegradationTag != ''">
				<eo_imageQualityDegradationTag><xsl:value-of select="used_eo_imageQualityDegradationTag"/></eo_imageQualityDegradationTag>
			</xsl:if>
			<xsl:if test="used_eo_processorName != ''">
				<eo_processorName><xsl:value-of select="used_eo_processorName"/></eo_processorName>
			</xsl:if>
			<xsl:if test="used_eo_processingCenter != ''">
				<eo_processingCenter><xsl:value-of select="used_eo_processingCenter"/></eo_processingCenter>
			</xsl:if>
			<xsl:if test="normalize-space($eoProcessingDate) != ''">
				<eo_processingDate><xsl:value-of select="normalize-space($eoProcessingDate)"/></eo_processingDate>
			</xsl:if>
			<xsl:if test="used_eo_sensorMode != ''">
				<eo_sensorMode><xsl:value-of select="used_eo_sensorMode"/></eo_sensorMode>
			</xsl:if>			
			<xsl:if test="used_eo_archivingCenter != ''">
				<eo_archivingCenter><xsl:value-of select="used_eo_archivingCenter"/></eo_archivingCenter>
			</xsl:if>
			<xsl:if test="used_eo_processingMode != ''">
				<eo_processingMode><xsl:value-of select="used_eo_processingMode"/></eo_processingMode>
			</xsl:if>
			<!-- OGC 13-026 Table 5 - OpenSearch Parameters for Acquistion Parameters Search -->
			<xsl:if test="used_eo_availabilityTime != ''">
				<eo_availabilityTime><xsl:value-of select="used_eo_availabilityTime"/></eo_availabilityTime>
			</xsl:if>
			<xsl:if test="used_eo_acquisitionStation != ''">
				<eo_acquisitionStation><xsl:value-of select="used_eo_acquisitionStation"/></eo_acquisitionStation>
			</xsl:if>
			<xsl:if test="used_eo_acquisitionSubType != ''">
				<eo_acquisitionSubType><xsl:value-of select="used_eo_acquisitionSubType"/></eo_acquisitionSubType>
			</xsl:if>
			<xsl:if test="used_eo_startTimeFromAscendingNode != ''">
				<eo_startTimeFromAscendingNode><xsl:value-of select="used_eo_startTimeFromAscendingNode"/></eo_startTimeFromAscendingNode>
			</xsl:if>
			<xsl:if test="used_eo_completionTimeFromAscendingNode != ''">
				<eo_completionTimeFromAscendingNode><xsl:value-of select="used_eo_completionTimeFromAscendingNode"/></eo_completionTimeFromAscendingNode>
			</xsl:if>
			<xsl:if test="used_eo_illuminationAzimuthAngle != ''">
				<eo_illuminationAzimuthAngle><xsl:value-of select="used_eo_illuminationAzimuthAngle"/></eo_illuminationAzimuthAngle>
			</xsl:if>
			<xsl:if test="used_eo_illuminationZenithAngle != ''">
				<eo_illuminationZenithAngle><xsl:value-of select="used_eo_illuminationZenithAngle"/></eo_illuminationZenithAngle>
			</xsl:if>
			<xsl:if test="used_eo_illuminationElevationAngle != ''">
				<eo_illuminationElevationAngle><xsl:value-of select="used_eo_illuminationElevationAngle"/></eo_illuminationElevationAngle>
			</xsl:if>
			<xsl:if test="used_eo_polarisationMode != ''">
				<eo_polarisationMode><xsl:value-of select="used_eo_polarisationMode"/></eo_polarisationMode>
			</xsl:if>
			<xsl:if test="used_eo_polarizationChannels != ''">
				<eo_polarizationChannels><xsl:value-of select="used_eo_polarizationChannels"/></eo_polarizationChannels>
			</xsl:if>
			<xsl:if test="used_eo_minimumIncidenceAngle != ''">
				<eo_minimumIncidenceAngle><xsl:value-of select="used_eo_minimumIncidenceAngle"/></eo_minimumIncidenceAngle>
			</xsl:if>
			<xsl:if test="used_eo_maximumIncidenceAngle != ''">
				<eo_maximumIncidenceAngle><xsl:value-of select="used_eo_maximumIncidenceAngle"/></eo_maximumIncidenceAngle>
			</xsl:if>
			<xsl:if test="used_eo_dopplerFrequency != ''">
				<eo_dopplerFrequency><xsl:value-of select="used_eo_dopplerFrequency"/></eo_dopplerFrequency>
			</xsl:if>
			<xsl:if test="used_eo_incidenceAngleVariation != ''">
				<eo_incidenceAngleVariation><xsl:value-of select="used_eo_incidenceAngleVariation"/></eo_incidenceAngleVariation>
			</xsl:if>
			<!-- Dublin Core -->
			<xsl:if test="used_dc_subject != ''">
				<dc_subject><xsl:value-of select="used_dc_subject"/></dc_subject>
			</xsl:if>
			<xsl:if test="used_dc_type != ''">
				<dc_type><xsl:value-of select="used_dc_type"/></dc_type>
			</xsl:if>
			<xsl:if test="used_dc_title != ''">
				<dc_title><xsl:value-of select="used_dc_title"/></dc_title>
			</xsl:if>
			<xsl:if test="used_dc_publisher != ''">
				<dc_publisher><xsl:value-of select="used_dc_publisher"/></dc_publisher>
			</xsl:if>
			<!-- Others -->
			<xsl:if test="used_semantic_classifiedAs != ''">
				<semantic_classifiedAs><xsl:value-of select="used_semantic_classifiedAs"/></semantic_classifiedAs>
			</xsl:if>
		</opensearchParameters>
	</xsl:template>
	<!-- ***************************************************************************
		Template is used to display search result
		*************************************************************************** !-->
	<xsl:template match="atom:feed">		
		<xsl:variable name="numberOfRecordsReturned" select="./os:itemsPerPage" />
		<xsl:variable name="numberOfRecordsMatched" select="./os:totalResults" />
		<xsl:variable name="startPosition" select="./os:startIndex" />
		<xsl:variable name="nextRecord" select="$startPosition + $numberOfRecordsReturned"/>
		<xsl:variable name="collectionHasData" select="'1'" />
		<xsl:variable name="datasetType">
			<xsl:for-each select="atom:entry[1]">
				<xsl:choose>
					<xsl:when test="gmi:MI_Metadata">						
						<xsl:value-of select="'CWIC'"/>
					</xsl:when>					
					<xsl:when test="eop:EarthObservation or opt:EarthObservation or sar:EarthObservation or atm:EarthObservation">
						<xsl:value-of select="'EOP'"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'GPOD'"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>							
		</xsl:variable>
		<elements numberOfRecordsReturned="{$numberOfRecordsReturned}" startPosition="{$startPosition}"
			numberOfRecordsMatched="{$numberOfRecordsMatched}" nextRecord="{$nextRecord}" maxRecordsMatched="{$numberOfRecordsMatched}"
 			collectionNumber="1" collectionHasData="{$collectionHasData}" displayedRecords="10"
 			datasetType="{normalize-space($datasetType)}">
			<!-- for displaying footprint -->
			<gmlEnveloppe>
				<sr:ServiceResult
					xmlns:sr="http://www.esa.int/xml/schemas/mass/serviceresult"
					xmlns="http://www.opengis.net/gml" xmlns:gml="http://www.opengis.net/gml"
					id="featCollection">
					<boundedBy>
						<Envelope srsName="EPSG:4326">
							<lowerCorner>-90 -180</lowerCorner>
							<upperCorner>90 180</upperCorner>
						</Envelope>
					</boundedBy>
				</sr:ServiceResult>
			</gmlEnveloppe>
			<xsl:for-each select="atom:entry">
				<xsl:apply-templates select=".">
					<xsl:with-param name="datasetType" select="normalize-space($datasetType)" />
				</xsl:apply-templates>
			</xsl:for-each>
		</elements>
	</xsl:template>
	<!-- ***************************************************************************
		Template is used to display entry details
		*************************************************************************** !-->
	<xsl:template match="atom:entry">
		<xsl:param name="datasetType"/>
			<xsl:choose>
				<!-- HMA EOP -->
				<xsl:when test="contains($datasetType,'EOP')">
					<xsl:for-each select="eop:EarthObservation">						
						<xsl:apply-templates select=".">
							<xsl:with-param name="georss" select="../georss:where" />
						</xsl:apply-templates>
					</xsl:for-each>
					<xsl:for-each select="opt:EarthObservation">						
						<xsl:apply-templates select=".">
							<xsl:with-param name="georss" select="../georss:where" />
						</xsl:apply-templates>
					</xsl:for-each>
					<xsl:for-each select="sar:EarthObservation">						
						<xsl:apply-templates select=".">
							<xsl:with-param name="georss" select="../georss:where" />
						</xsl:apply-templates>
					</xsl:for-each>
					<xsl:for-each select="atm:EarthObservation">						
						<xsl:apply-templates select=".">
							<xsl:with-param name="georss" select="../georss:where" />
						</xsl:apply-templates>
					</xsl:for-each>
				</xsl:when>
				<!-- CWIC -->
				<xsl:when test="contains($datasetType,'CWIC')">
					<xsl:for-each select="gmi:MI_Metadata">
						<xsl:apply-templates select="."/>
					</xsl:for-each>
				</xsl:when>
				<!-- GPOD, Supersite -->
				<xsl:otherwise>
					<xsl:variable name="startDate" select="gml:validTime/gml:TimePeriod/gml:beginPosition"/>
					<xsl:variable name="endDate" select="gml:validTime/gml:TimePeriod/gml:endPosition"/>
					<xsl:variable name="productId" select="atom:id"/>
					<element productId="{$productId}">
						<property name="omMetadataURL">
							<xsl:value-of select="atom:link[@type='application/gml+xml']/@href"/>
						</property>
						<!-- for displaying footprint -->
						<gmlFeature>
							<gml:featureMember xmlns:gml="http://www.opengis.net/gml">
								<Feature xmlns="http://www.esa.int/xml/schemas/mass/serviceresult">
									<xsl:attribute name="gml:id">
										<xsl:value-of select="$productId" />
									</xsl:attribute>
									<id>
										<xsl:value-of select="$productId" />
									</id>
									<tooltip>
										<xsl:value-of select="$productId" />
									</tooltip>											
									<xsl:if test="$startDate != ''">
										<attribute13>
											Start Date, <xsl:value-of select="$startDate" />
										</attribute13>
									</xsl:if>
									<xsl:if test="$endDate != ''">
										<attribute14>
											End Date, <xsl:value-of select="$endDate" />
										</attribute14>
									</xsl:if>
									<geometry>
										<xsl:copy-of select="georss:where/child::*" />
									</geometry>					
								</Feature>
							</gml:featureMember>
						</gmlFeature>
						<property name="startDate">
							<xsl:value-of select="$startDate"/>
						</property>	
						<property name="endDate">
							<xsl:value-of select="$endDate"/>
						</property>
						<xsl:choose>
							<xsl:when test="atom:content[@type='html']">
								<property name="htmlContent">
									<xsl:value-of select="atom:content[@type='html']"/>
								</property>
							</xsl:when>
							<xsl:otherwise>
								<property name="htmlContent">
									<xsl:value-of select="atom:summary[@type='html']"/>
								</property>
							</xsl:otherwise>
						</xsl:choose>
					</element>
				</xsl:otherwise>
			</xsl:choose>		
	</xsl:template>
	
	<!-- HMA EOP -->
	<xsl:template match="eop:EarthObservation">
		<xsl:param name="georss"/>
		<xsl:call-template name="EarthObservation">
			<xsl:with-param name="self" select="." />
			<xsl:with-param name="georss" select="$georss" />
		</xsl:call-template>
	</xsl:template>
	<!-- HMA OPT -->
	<xsl:template match="opt:EarthObservation">	
		<xsl:param name="georss"/>
		<xsl:call-template name="EarthObservation">
			<xsl:with-param name="self" select="." />
			<xsl:with-param name="georss" select="$georss" />
		</xsl:call-template>
	</xsl:template>
	<!-- HMA SAR -->
	<xsl:template match="sar:EarthObservation">	
		<xsl:param name="georss"/>
		<xsl:call-template name="EarthObservation">
			<xsl:with-param name="self" select="." />
			<xsl:with-param name="georss" select="$georss" />
		</xsl:call-template>
	</xsl:template>
	<!-- HMA ATM -->
	<xsl:template match="atm:EarthObservation">	
		<xsl:param name="georss"/>
		<xsl:call-template name="EarthObservation">
			<xsl:with-param name="self" select="." />
			<xsl:with-param name="georss" select="$georss" />
		</xsl:call-template>
	</xsl:template>
				
	<!-- CWIC ISO -->
	<xsl:template match="gmi:MI_Metadata">
		<xsl:variable name="productId" select="./gmd:fileIdentifier/gco:CharacterString"/>
		<xsl:variable name="startDate" select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml32:TimePeriod/gml32:beginPosition"/>
		<xsl:variable name="endDate" select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gml32:TimePeriod/gml32:endPosition"/>
		
		<xsl:variable name="a"
			select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude/gco:Decimal" />
		<xsl:variable name="b"
			select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude/gco:Decimal" />
		<xsl:variable name="c"
			select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude/gco:Decimal" />
		<xsl:variable name="d"
			select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude/gco:Decimal" />
		<xsl:variable name="space" select="' '" />
		
		<element productId="{$productId}">
			<!-- for displaying footprints -->
			<gmlFeature>				
				<gml:featureMember xmlns:gml="http://www.opengis.net/gml">
					<Feature xmlns="http://www.esa.int/xml/schemas/mass/serviceresult">
						<id>
							<xsl:value-of select="$productId" />
						</id>
						<tooltip>
							<xsl:value-of select="$productId" />
						</tooltip>
						<xsl:if test="$startDate != ''">
							<attribute13>
								Start Date, <xsl:value-of select="$startDate" />
							</attribute13>
						</xsl:if>
						<xsl:if test="$endDate != ''">
							<attribute14>
								End Date, <xsl:value-of select="$endDate" />
							</attribute14>
						</xsl:if>
						<geometry>
							<Polygon xmlns="http://www.opengis.net/gml" srsName="EPSG:4326">
								<exterior>
									<LinearRing>
										<posList>																				
											<xsl:value-of select="$b" />
											<xsl:value-of
												select="$space" />
											<xsl:value-of select="$a" />											
											<xsl:value-of
												select="$space" />
												
											<xsl:value-of select="$d" />
											<xsl:value-of
												select="$space" />
											<xsl:value-of select="$a" />
											<xsl:value-of
												select="$space" />
												
											<xsl:value-of select="$d" />
											<xsl:value-of
												select="$space" />
											<xsl:value-of select="$c" />
											<xsl:value-of
												select="$space" />
												
											<xsl:value-of select="$b" />
											<xsl:value-of
												select="$space" />
											<xsl:value-of select="$c" />
											<xsl:value-of
												select="$space" />
												
											<xsl:value-of select="$b" />
											<xsl:value-of
												select="$space" />
											<xsl:value-of select="$a" />
										</posList>
									</LinearRing>
								</exterior>
							</Polygon>
						</geometry>
					</Feature>
				</gml:featureMember>
			</gmlFeature>
			<property name="identifier">
				<xsl:value-of select="$productId"/>
			</property>
			<property name="parentId">
				<xsl:value-of select="substring-before($productId,':')"/>
			</property>			
			<property name="startDate">
				<xsl:value-of select="$startDate"/>
			</property>	
			<property name="endDate">
				<xsl:value-of select="$endDate"/>
			</property>	
			<property name="language">
				<xsl:value-of select="./gmd:language/gco:CharacterString"/>
			</property>	
			<property name="hierarchyLevel">
				<xsl:value-of select="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue"/>
			</property>	
			<xsl:for-each select="gmd:identificationInfo/gmd:MD_DataIdentification">
				<property name="title">
					<xsl:value-of select="gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
				</property>	
				<property name="abstract">
					<xsl:value-of select="gmd:abstract/gco:CharacterString"/>
				</property>
			</xsl:for-each>
			<xsl:for-each select="gmd:distributionInfo/gmd:MD_Distribution">
				<property name="format">
					<xsl:value-of select="gmd:distributionFormat/gmd:MD_Format/gmd:name/gco:CharacterString"/>
				</property>
				<property name="size">
					<xsl:value-of select="gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:transferSize/gco:Real"/>
				</property>
				<xsl:for-each select="gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine">				
					<group name="online">
						<property name="linkage">
							<xsl:value-of select="gmd:CI_OnlineResource/gmd:linkage/gmd:URL" />
						</property>
						<property name="protocol">
							<xsl:value-of select="gmd:CI_OnlineResource/gmd:protocol/gco:CharacterString" />
						</property>
						<property name="name">
							<xsl:value-of select="gmd:CI_OnlineResource/gmd:name/gco:CharacterString" />
						</property>
						<property name="description">
							<xsl:value-of select="gmd:CI_OnlineResource/gmd:description/gco:CharacterString" />
						</property>
						<property name="function">
							<xsl:value-of select="gmd:CI_OnlineResource/gmd:function/gmd:CI_OnLineFunctionCode/@codeListValue" />
						</property>
					</group>			
				</xsl:for-each>			
			</xsl:for-each>
			<xsl:for-each select="gmi:acquisitionInformation/gmi:MI_AcquisitionInformation">
				<property name="platform">
					<xsl:value-of select="gmi:platform/gmi:MI_Platform/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
				</property>
				<property name="instrument">
					<xsl:value-of select="gmi:platform/gmi:MI_Platform/gmi:instrument/gmi:MI_Instrument/gmi:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
				</property>
			</xsl:for-each>
		</element>
	</xsl:template>
	
	<!-- HMA EarthObservation -->
	<xsl:template name="EarthObservation">
		<xsl:param name="self"/>
		<xsl:param name="georss"/>			
		<xsl:variable name="productId" select="$self/eop:metaDataProperty/eop:EarthObservationMetaData/eop:identifier"/>
		<xsl:variable name="orbitNumber">
			<xsl:choose>
				<xsl:when test="$self/om:procedure/eop:EarthObservationEquipment/eop:acquisitionParameters/sar:Acquisition/eop:orbitNumber">
					<xsl:value-of select="$self/om:procedure/eop:EarthObservationEquipment/eop:acquisitionParameters/sar:Acquisition/eop:orbitNumber"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$self/om:procedure/eop:EarthObservationEquipment/eop:acquisitionParameters/eop:Acquisition/eop:orbitNumber"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="platformShortName" select="normalize-space($self/om:procedure/eop:EarthObservationEquipment/eop:platform/eop:Platform/eop:shortName)"/>
		<xsl:variable name="startDate" select="normalize-space($self/om:phenomenonTime/gml32:TimePeriod/gml32:beginPosition)"/>
		<xsl:variable name="endDate" select="normalize-space($self/om:phenomenonTime/gml32:TimePeriod/gml32:endPosition)"/>
		
		<element productId="{$productId}">
			<!-- for displaying footprints -->
			<gmlFeature>
				<gml:featureMember xmlns:gml="http://www.opengis.net/gml">
					<Feature xmlns="http://www.esa.int/xml/schemas/mass/serviceresult">
						<xsl:attribute name="gml:id">
							<xsl:value-of select="$productId" />
						</xsl:attribute>
						<id>
							<xsl:value-of select="$productId" />
						</id>
						<tooltip>
							<xsl:value-of select="$productId" />
						</tooltip>
						<xsl:if test="$platformShortName != ''">
							<attribute1>
								Platform, <xsl:value-of select="$platformShortName" />
							</attribute1>
						</xsl:if>					
						<xsl:if test="$orbitNumber !=''">
							<attribute5>
								Orbit, <xsl:value-of select="$orbitNumber" />
							</attribute5>
						</xsl:if>					
						<xsl:if test="$startDate != ''">
							<attribute13>
								Start Date, <xsl:value-of select="$startDate" />
							</attribute13>
						</xsl:if>
						<xsl:if test="$endDate != ''">
							<attribute14>
								End Date, <xsl:value-of select="$endDate" />
							</attribute14>
						</xsl:if>
						<geometry>
							<xsl:copy-of select="$georss/child::*" />
						</geometry>					
					</Feature>
				</gml:featureMember>
			</gmlFeature>
			<property name="startDate">
				<xsl:value-of select="normalize-space($startDate)" />
			</property>
			<property name="endDate">
				<xsl:value-of select="normalize-space($endDate)" />
			</property>		
			<property name="orbitNumber">
				<xsl:value-of select="normalize-space($orbitNumber)" />
			</property>
			<property name="platformShortName">
				<xsl:value-of select="normalize-space($platformShortName)" />
			</property>
			
			<!-- EarthObservationEquipment -->
			<xsl:for-each select="$self/om:procedure/eop:EarthObservationEquipment">
				<property name="serialIdentifier">
					<xsl:value-of select="eop:serialIdentifier" />
				</property>
				<property name="orbitType">
					<xsl:value-of select="eop:orbitType" />
				</property>
				<property name="instrumentShortName">
					<xsl:value-of select="eop:instrument/eop:Instrument/eop:shortName" />
				</property>
				
				<xsl:for-each select="eop:sensor/eop:Sensor">
					<property name="sensorType">
						<xsl:value-of select="eop:sensorType" />
					</property>
					<property name="operationalMode">
						<xsl:value-of select="eop:operationalMode" />
					</property>
					<property name="resolution">
						<xsl:value-of select="eop:resolution" />
					</property>
					<property name="swathIdentifier">
						<xsl:value-of select="eop:swathIdentifier" />
					</property>
				</xsl:for-each>
				
				<xsl:for-each select="eop:acquisitionParameters/sar:Acquisition">
					<xsl:call-template name="Acquisition">
						<xsl:with-param name="self" select="." />
					</xsl:call-template>
				</xsl:for-each>
				<xsl:for-each select="eop:acquisitionParameters/eop:Acquisition">
					<xsl:call-template name="Acquisition">
						<xsl:with-param name="self" select="." />
					</xsl:call-template>
				</xsl:for-each>
			</xsl:for-each>
			
			<!-- EarthObservationResult -->
			<xsl:for-each select="$self/om:result">
				<!-- OPT -->
				<xsl:for-each select="opt:EarthObservationResult">
					<property name="cloudCoverPercentage">
						<xsl:value-of select="opt:cloudCoverPercentage" />
					</property>
					<property name="snowCoverPercentage">
						<xsl:value-of select="opt:snowCoverPercentage" />
					</property>
				</xsl:for-each>
				<!-- ATM -->
				<xsl:for-each select="atm:EarthObservationResult">
					<xsl:for-each select="atm:dataLayers/atm:DataLayer">
						<property name="algorithmName">
							<xsl:value-of select="atm:algorithmName" />
						</property>
						<property name="algorithmVersion">
							<xsl:value-of select="atm:algorithmVersion" />
						</property>
						<property name="species">
							<xsl:value-of select="atm:species" />
						</property>
						<property name="unit">
							<xsl:value-of select="atm:unit" />
						</property>
					</xsl:for-each>				
				</xsl:for-each>
				<!-- BrowseInformation -->
				<xsl:for-each select="*/eop:browse/eop:BrowseInformation">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
				<!-- MaskInformation -->
				<xsl:for-each select="*/eop:mask/eop:MaskInformation">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</xsl:for-each>
			
			<!-- EarthObservationMetaData -->
			<xsl:for-each select="$self/eop:metaDataProperty/eop:EarthObservationMetaData">
				<property name="parentId">
					<xsl:value-of select="eop:parentIdentifier" />
				</property>
				<property name="identifier">
					<xsl:value-of select="eop:identifier" />
				</property>
				<property name="doi">
					<xsl:value-of select="eop:doi" />
				</property>
				<property name="acquisitionType">
					<xsl:value-of select="eop:acquisitionType" />
				</property>
				<property name="acquisitionSubType">
					<xsl:value-of select="eop:acquisitionSubType" />
				</property>
				<property name="productType">
					<xsl:value-of select="eop:productType" />
				</property>
				<property name="status">
					<xsl:value-of select="eop:status" />
				</property>
				<property name="acquisitionStation">
					<xsl:value-of select="eop:downlinkedTo/eop:DownlinkInformation/eop:acquisitionStation" />
				</property>
				<property name="acquisitionDate">
					<xsl:value-of select="eop:downlinkedTo/eop:DownlinkInformation/eop:acquisitionDate" />
				</property>
				<property name="archivingCenter">
					<xsl:value-of select="eop:archivedIn/eop:ArchivingInformation/eop:archivingCenter" />
				</property>
				<property name="archivingDate">
					<xsl:value-of select="eop:archivedIn/eop:ArchivingInformation/eop:archivingDate" />
				</property>
				<property name="archivingIdentifier">
					<xsl:value-of select="eop:archivedIn/eop:ArchivingInformation/eop:archivingIdentifier" />
				</property>
				<property name="imageQualityDegradationQuotationMode">
					<xsl:value-of select="eop:imageQualityDegradationQuotationMode" />
				</property>
			</xsl:for-each>
		</element>
	</xsl:template>
			
	<!-- eop:BrowseInformation -->
	<xsl:template match="eop:BrowseInformation">
		<property name="browseType">
			<xsl:value-of select="eop:type" />
		</property>
		<property name="browseSubType">
			<xsl:value-of select="eop:subType" />
		</property>
		<property name="browseReferenceSystemIdentifier">
			<xsl:value-of select="eop:referenceSystemIdentifier" />
		</property>
		<property name="browseFileName">
			<xsl:value-of select="eop:fileName/ows:ServiceReference/@xlink:href" />
		</property>
		
		<xsl:choose>
			<xsl:when test="eop:type = 'THUMBNAIL'">
				<xsl:variable name="imageURL"
					select="eop:fileName/ows:ServiceReference/@xlink:href" />
				<xsl:choose>
					<xsl:when test="$imageURL != ''">
						<property name="preview">
							<xsl:value-of select="$imageURL" />
						</property>
					</xsl:when>
					<xsl:otherwise>
						<property name="preview">
							No preview
						</property>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="imageURL"
					select="eop:fileName[1]/ows:ServiceReference/@xlink:href" />
				<xsl:choose>
					<xsl:when test="$imageURL != ''">
						<property name="image">
							<xsl:value-of select="$imageURL" />
						</property>
					</xsl:when>
					<xsl:otherwise>
						<property name="image">
							No preview
						</property>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>	
	
	<xsl:template match="eop:MaskInformation">
		<property name="maskType">
			<xsl:value-of select="eop:type" />
		</property>
		<property name="maskFormat">
			<xsl:value-of select="eop:format" />
		</property>
		<property name="maskReferenceSystemIdentifier">
			<xsl:value-of select="eop:referenceSystemIdentifier" />
		</property>
		<property name="maskFileName">
			<xsl:value-of select="eop:fileName/ows:ServiceReference/@xlink:href" />
		</property>
	</xsl:template>
	
	<!-- Acquisition -->
	<xsl:template name="Acquisition">
		<xsl:param name="self"/>
		
		<property name="lastOrbitNumber">
			<xsl:value-of select="$self/eop:lastOrbitNumber" />
		</property>
		<property name="orbitDirection">
			<xsl:value-of select="$self/eop:orbitDirection" />
		</property>
		<property name="wrsLongitudeGrid">
			<xsl:value-of select="$self/eop:wrsLongitudeGrid" />
		</property>
		<property name="wrsLatitudeGrid">
			<xsl:value-of select="$self/eop:wrsLatitudeGrid" />
		</property>
		<property name="ascendingNodeDate">
			<xsl:value-of select="$self/eop:ascendingNodeDate" />
		</property>
		<property name="ascendingNodeLongitude">
			<xsl:value-of select="$self/eop:ascendingNodeLongitude" />
		</property>
		<property name="startTimeFromAscendingNode">
			<xsl:value-of select="$self/eop:startTimeFromAscendingNode" />
		</property>
		<property name="completionTimeFromAscendingNode">
			<xsl:value-of select="$self/eop:completionTimeFromAscendingNode" />
		</property>
		<property name="orbitDuration">
			<xsl:value-of select="$self/eop:orbitDuration" />
		</property>
		<property name="illuminationAzimuthAngle">
			<xsl:value-of select="$self/eop:illuminationAzimuthAngle" />
		</property>
		<property name="illuminationElevationAngle">
			<xsl:value-of select="$self/eop:illuminationElevationAngle" />
		</property>
		<property name="incidenceAngle">
			<xsl:value-of select="$self/eop:incidenceAngle" />
		</property>
		<property name="acrossTrackIncidenceAngle">
			<xsl:value-of select="$self/eop:acrossTrackIncidenceAngle" />
		</property>
		<property name="alongTrackIncidenceAngle">
			<xsl:value-of select="$self/eop:alongTrackIncidenceAngle" />
		</property>
		<property name="pitch">
			<xsl:value-of select="$self/eop:pitch" />
		</property>
		<property name="roll">
			<xsl:value-of select="$self/eop:roll" />
		</property>
		<property name="yaw">
			<xsl:value-of select="$self/eop:yaw" />
		</property>
		<property name="polarisationMode">
			<xsl:value-of select="$self/sar:polarisationMode" />
		</property>
		<property name="polarisationChannels">
			<xsl:value-of select="$self/sar:polarisationChannels" />
		</property>
		<property name="antennaLookDirection">
			<xsl:value-of select="$self/sar:antennaLookDirection" />
		</property>
		<property name="minimumIncidenceAngle">
			<xsl:value-of select="$self/sar:minimumIncidenceAngle" />
		</property>
		<property name="incidenceAngleVariation">
			<xsl:value-of select="$self/sar:incidenceAngleVariation" />
		</property>
		<property name="dopplerFrequency">
			<xsl:value-of select="$self/sar:dopplerFrequency" />
		</property>
	</xsl:template>	
</xsl:stylesheet>

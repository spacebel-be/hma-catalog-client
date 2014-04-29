<xsl:stylesheet version="1.0" xmlns:mass="http://www.esa.int/mass"
	xmlns:sse="http://www.esa.int/mass"
	xmlns:serviceNS="http://www.spacebel.be/sse"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:oi="http://www.esa.int/oi"
	xmlns:aoi="http://www.esa.int/xml/schemas/mass/aoifeatures"
	xmlns:ows="http://www.opengis.net/ows"
	xmlns:gml="http://www.opengis.net/gml"
	xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
	xmlns:ogc="http://www.opengis.net/ogc"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dct="http://purl.org/dc/terms/"	
	xmlns:common="http://exslt.org/common">
	<!-- Import statements -->	
	<xsl:import href="./exceptionHandle.xsl"/>
	<xsl:import href="./icd/ogc-07-038/ogc-07-038-v0111-csw-catalogue.xsl"/>	
	<xsl:param name="part" />
	<xsl:variable name="useWorkflow">
	</xsl:variable>
	<xsl:variable name="keywordDesSupported"> 			 
	</xsl:variable>
	<xsl:variable name="keywordURISupported">
	</xsl:variable>
	<xsl:template match="/*">
		<xsl:choose>
			<!-- *********************************************************
				Search
				*********************************************************-->
			<!-- Used for service's Search presentation and processing -->
			<xsl:when test="$part='sendSearchInputHTML'">
				<xsl:apply-templates select="mass:sendSearchInput"/>
			</xsl:when>
			<xsl:when test="$part='processSearchInputXML'">				
				<xsl:choose>
					 <xsl:when test="normalize-space($useWorkflow)='yes'">
						<serviceNS:multiCataloguesSearchInputMsg
							xmlns:sse="http://www.esa.int/mass"
							xmlns:aoi="http://www.esa.int/xml/schemas/mass/aoifeatures"
							xmlns:oi="http://www.esa.int/oi">					
							<xsl:apply-templates select="serviceNS:sendSearchInput" mode="XML" />					
						</serviceNS:multiCataloguesSearchInputMsg>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="serviceNS:sendSearchInput" mode="XML"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$part='getSearchOutputHTML'">
				<xsl:call-template name="generateSearchOutput">
 					<xsl:with-param name="displayedRecords">10</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>
	<!-- ***************************************************************************
		Templates used to display Search input information using XML format
		*************************************************************************** !-->
	<xsl:template match="mass:sendSearchInput">
		<inputSearchDefaults xmlns="http://www.spacebel.be/jsf/interface/search">
			<input type="string_as_child" name="defaultTab">
				Series
			</input>			
			<input type="boolean" name="enabledTab-any" />
			<input type="boolean" name="enabledTab-collection" />
			<input type="boolean" name="enabledTab-service" />
			<input type="string" name="used_abstract#any" />
			<input type="string" name="used_subject#any" />
			<input type="string" name="used_abstract#collection" />			
			<input type="string" name="used_subject#collection" />
			<input type="string" name="used_abstract#service" />
			<input type="string" name="used_subject#service" />			
			<input type="string" name="iteratorSize" value="10" />
			<input type="integer" name="used_iteratorSize" value="10" />
		</inputSearchDefaults>
	</xsl:template>
	
	<xsl:template match="serviceNS:sendSearchInput" mode="XML">	
		<xsl:variable name="typeName" select="typeHidden"/>
		<xsl:variable name="numOfCollection" select="count(collectionId)"/>
		<xsl:variable name="objectEO">
			<xsl:if test="typeHidden = 'any'">
				rim:ExtrinsicObject		
			</xsl:if>
			
			<xsl:if test="typeHidden = 'instrument'">
				rim:ExtrinsicObject	rim:ExtrinsicObject_sensor Association Classification	Classification_classSubType
				<xsl:if test="normalize-space(used_service) != ''">
					Association_asso  Classification_class Service  ClassificationNode	
				</xsl:if>						
				<xsl:if test="normalize-space(used_dectShortname) != '' or normalize-space(used_dectAlongRes) != '' or normalize-space(used_dectAcrossRes) != '' or normalize-space(used_dectNumberOfSamples) != ''">						
					rim:ExtrinsicObject_detector Association_insDectAss Classification_classDecSubType
				</xsl:if>	
				<xsl:if test="normalize-space(used_sensorType) != ''">Classification_classSensorType ClassificationNode_classNodeSensorType</xsl:if>
				<xsl:if test="normalize-space(used_intendedApplication) != ''">Classification_classIntApp ClassificationNode_classNodeIntApp</xsl:if>
			</xsl:if>
				
			<xsl:if test="typeHidden != 'any' and typeHidden != 'instrument'">
				rim:ExtrinsicObject	Classification		
			</xsl:if>
			
			<xsl:if test="used_language != '' or used_datasetLanguage != '' or used_parentIdentifier != '' or used_fileIdentifier">
			<!--used_datasetLanguage used_language used_alternateTitle used_parentIdentifier-->
				rim:ExtrinsicObject_metadata Association
			</xsl:if>				
			<xsl:if test="used_keyword != '' or used_subject !=''">			
				Classification_classKeyWordUrl ClassificationNode_classNodeKeyWordUrl
			</xsl:if>					
			<xsl:if test="used_keywordType != ''">				
				Classification_classKeyWordType  Classification_classKeyWordScheme ClassificationNode_classKeyWordSchemeNode
			</xsl:if>							
			<xsl:if test="used_organisationName != ''">
				rim:ExtrinsicObject_metadataInfoOrganization Association_associationOrangizationrim:ExtrinsicObject Association_associationOrangizationMetadataInfo Organization
			</xsl:if>			
			<xsl:if test="used_topicCategory != ''">								
				Classification_classTopic ClassificationNode_classNodeTopic				
			</xsl:if>					
			<xsl:if test="used_couplingType != ''">
				Classification_classCouplingType ClassificationNode_classNodeCouplingType
			</xsl:if>					
			<xsl:if test="used_hasSecurityConstraint != ''"> 
				rim:ExtrinsicObject_metadataInfoSecurity Association Association_associationSecurity SecurityConstraints				
			</xsl:if>
			<xsl:if test="used_operation != ''">
				rim:ExtrinsicObject_serviceOperation Classification_classOperation ClassificationNode_classNodeOperation Association_associationOperation
			</xsl:if>
			<xsl:if test="used_dCP != ''">
				rim:ExtrinsicObject_serviceOperationEO Classification_classDCP ClassificationNode_classNodeDCP Association_associationServiceOperation   
			</xsl:if>
			<xsl:if test="used_serviceType != ''">
				Classification_class4ServiceType ClassificationNode_classNode4ServiceType
			</xsl:if>
			
			<xsl:if test="used_serviceTypeVer != ''">
				Classification_class4ServiceTypeVer ClassificationNode_classNode4ServiceTypeVer
			</xsl:if>
			
			<xsl:if test="used_operateOn != ''">
				rim:ExtrinsicObject_Metadata4Operation rim:ExtrinsicObject_metadata Association_association4OperationOn	Association_associatiDataset				
			</xsl:if>
		</xsl:variable>	
		<GetRecords xmlns="http://www.opengis.net/cat/csw/2.0.2" 
			xmlns:gml="http://www.opengis.net/gml" 
			xmlns:wrs="http://www.opengis.net/cat/wrs/1.0" 
			xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0"
			service="CSW" outputFormat="application/xml" version="2.0.2" 
			resultType="results" outputSchema="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
			
			<xsl:attribute name="maxRecords">10</xsl:attribute>			
			<xsl:attribute name="startPosition"><xsl:value-of select="used_cursor" /></xsl:attribute>
			<Query>
				<xsl:attribute name="typeNames"><xsl:value-of select="normalize-space($objectEO)" /></xsl:attribute>							
				<ElementSetName typeNames="rim:ExtrinsicObject">full</ElementSetName>
				<Constraint version="1.1.0">
					<Filter xmlns="http://www.opengis.net/ogc">
						<And>	
							<PropertyIsLike escapeChar="!" singleChar="?" wildCard="*">
								<PropertyName>/rim:ExtrinsicObject/rim:Description/LocalizedString/@value</PropertyName>
								<Literal>*</Literal>
							</PropertyIsLike>
							<xsl:if test="typeHidden = 'any'">
								<Or>						
									<PropertyIsEqualTo>
										<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
										<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DataMetadata</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
										<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DatasetCollection</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
										<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::ServiceMetadata</Literal>
									</PropertyIsEqualTo>
								</Or>									 
							</xsl:if>
							
							<!-- Search type Service -->
							<xsl:if test="typeHidden = 'service'">
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<!-- Version 0.1.11 -->
									<!-- <Literal>urn:ogc:def:ebRIM-ObjectType:OGC:ServiceMetadata</Literal>-->
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::ServiceMetadata</Literal>													 
								 </PropertyIsEqualTo>
							</xsl:if>	
						
							<xsl:if test="typeHidden = 'collection'">
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>											
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DatasetCollection</Literal>											
								</PropertyIsEqualTo>									
							</xsl:if>
							
							<xsl:if test="typeHidden = 'instrument'">																				
								<!-- Collection filter -->
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DatasetCollection</Literal>
								</PropertyIsEqualTo>
								<!-- Sensor filter -->
								<PropertyIsEqualTo>
									<PropertyName>$sensor/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-Sensor::System</Literal>
								</PropertyIsEqualTo>	
								<PropertyIsEqualTo>										
									<PropertyName>$sensor/@id</PropertyName>
									<PropertyName>$classSubType/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classSubType/@classificationNode</PropertyName>
									<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-Sensor::SystemTypes:SensorType</Literal>
								</PropertyIsEqualTo>

								<!-- Collection >> Instrument Association -->
								<PropertyIsEqualTo>
									<PropertyName>/Association/@associationType</PropertyName>
									<Literal>urn:ogc:def:associationType:OGC-CSW-ebRIM-CIM::AcquiredBy</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Association/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Association/@targetObject</PropertyName>
									<PropertyName>$sensor/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<!-- Start Date -->
								<xsl:if test="(used_startDate != '')">								
									<PropertyIsGreaterThanOrEqualTo>										
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::ValidTimeBegin']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="used_startDate"/>T00:00:00.000</Literal>
									</PropertyIsGreaterThanOrEqualTo>
								</xsl:if>			
							
								<!-- Start Date -->
								<xsl:if test="(used_endDate!= '')">								
									<PropertyIsLessThanOrEqualTo>										
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::ValidTimeEnd']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="used_endDate"/>T23:59:59.000</Literal>
									</PropertyIsLessThanOrEqualTo>
								</xsl:if>
						
								<!-- Phenomenon queryable -->
								<xsl:if test="used_phenomenon != ''">
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::Outputs']/rim:ValueList/rim:Value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_phenomenon)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>
							
								<!-- Inputs parameter -->								
								<xsl:if test="used_inputs != ''">
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::Inputs']/rim:ValueList/rim:Value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_inputs)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>
							
								<!-- Description parameter -->
								<xsl:if test="used_description != ''">
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$sensor/Description/LocalizedString/@value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_description)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>
							
								<!-- shortname parameter -->
								<xsl:if test="used_insShortname != ''">
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::ShortName']/rim:ValueList/rim:Value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_insShortname)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>
							
								<!-- longname parameter -->
								<xsl:if test="used_insLongname != ''">
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">											
										<PropertyName>$sensor/Name/LocalizedString/@value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_insLongname)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>
							
								<!-- If one of the queryable belongs to detector is select -->
								<xsl:if test="normalize-space(used_dectShortname) != '' or normalize-space(used_dectAlongRes) != '' or normalize-space(used_dectAcrossRes) != '' or normalize-space(used_dectNumberOfSamples) != ''">																									
									<!-- First Create query to link Detector with Instrument -->
									<PropertyIsEqualTo>
										<PropertyName>$detector/@objectType</PropertyName>
										<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-Sensor::Component</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$detector/@id</PropertyName>
										<PropertyName>$classDecSubType/@classifiedObject</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$classDecSubType/@classificationNode</PropertyName>
										<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-Sensor::SystemTypes:DetectorType</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$insDectAss/@associationType</PropertyName>
										<Literal>urn:ogc:def:association:OGC-CSW-ebRIM-Sensor::ComposedOf</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$insDectAss/@sourceObject</PropertyName>
										<PropertyName>$sensor/@id</PropertyName>
									</PropertyIsEqualTo>										
									<PropertyIsEqualTo>
										<PropertyName>$insDectAss/@targetObject</PropertyName>
										<PropertyName>$detector/@id</PropertyName>
									</PropertyIsEqualTo>
									
									<!-- Detector short name -->
									<xsl:if test="used_dectShortname != ''">									
										<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
											<PropertyName>$detector/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::ShortName']/rim:ValueList/rim:Value</PropertyName>
											<Literal>
												<xsl:call-template name="surroundString">
													<xsl:with-param name="string" select="normalize-space(used_dectShortname)"/>
													<xsl:with-param name="surroundChar">*</xsl:with-param>
												</xsl:call-template>
											</Literal>
										</PropertyIsLike>
									</xsl:if>
									
									<!-- Detector Number Of Samples  -->
									<xsl:if test="used_dectNumberOfSamples != ''">										
										<PropertyIsLessThanOrEqualTo>
											<PropertyName>$detector/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::NumberOfSamples']/rim:ValueList/rim:Value</PropertyName>
											<Literal><xsl:value-of select="normalize-space(used_dectNumberOfSamples)"/></Literal>
										</PropertyIsLessThanOrEqualTo>										
									</xsl:if>
									
									<!-- Detector Along Track Ground Resolution  -->
									<xsl:if test="used_dectAlongRes != ''">										
										<PropertyIsLessThanOrEqualTo>
											<PropertyName>$detector/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::AlongTrackGroundResolution']/rim:ValueList/rim:Value</PropertyName>
											<Literal><xsl:value-of select="normalize-space(used_dectAlongRes)"/></Literal>
										</PropertyIsLessThanOrEqualTo>										
									</xsl:if>
								
									<!-- Detector Accross Track Ground Resolution  -->
									<xsl:if test="used_dectAcrossRes != ''">										
										<PropertyIsLessThanOrEqualTo>
											<PropertyName>$detector/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::AcrossTrackGroundResolution']/rim:ValueList/rim:Value</PropertyName>
											<Literal><xsl:value-of select="normalize-space(used_dectAcrossRes)"/></Literal>
										</PropertyIsLessThanOrEqualTo>										
									</xsl:if>
								</xsl:if>
														
								<!-- Keyword queryable -->
								<xsl:if test="used_keywords != ''">
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::Keywords']/rim:ValueList/rim:Value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_keywords)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>
								
								<!-- AOI parameter -->								
								<xsl:if test="//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope != ''">								
									<BBOX>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::ObservedBoundingBox']/ValueList/AnyValue</PropertyName>
										<xsl:copy-of select="//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope"/>
									</BBOX>
								</xsl:if>
							
								<!-- IntendedApplication parameter -->								
								<xsl:if test="used_intendedApplication != ''">
									<PropertyIsEqualTo>
										<PropertyName>$sensor/@id</PropertyName>
										<PropertyName>$classIntApp/@classifiedObject</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$classNodeIntApp/@id</PropertyName>
										<PropertyName>$classIntApp/@classificationNode</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$classNodeIntApp/Name/LocalizedString/@value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_intendedApplication)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>	
									<PropertyIsEqualTo>
										<PropertyName>$classIntApp/@classificationScheme</PropertyName>
										<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-Sensor::IntendedApplication</Literal>
									</PropertyIsEqualTo>		
								</xsl:if>
					
								<xsl:if test="used_service != ''">
									<PropertyIsEqualTo>
										<PropertyName>$asso/@associationType</PropertyName>
										<Literal>urn:ogc:def:association:OGC-CSW-ebRIM-Sensor::AccessibleThrough</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$asso/@sourceObject</PropertyName>
										<PropertyName>$sensor/@id</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$asso/@targetObject</PropertyName>
										<PropertyName>/Service/@id</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>/Service/@id</PropertyName>
										<PropertyName>$class/@classifiedObject</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$class/@classificationNode</PropertyName>
										<PropertyName>/ClassificationNode/@id</PropertyName>												
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$class/@classificationScheme</PropertyName>
										<Literal>urn:ogc:def:ebRIM-ClassificationScheme:ISO-19119:2005:Services</Literal>
									</PropertyIsEqualTo>
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>/ClassificationNode/Name/LocalizedString/@value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_service)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>	
							
								<!-- acrossTrackPointing parameter -->
								<xsl:if test="used_acrossTrackPointing != ''">
									<PropertyIsGreaterThanOrEqualTo>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::acrossTrackPointingUpperBound']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="normalize-space(used_acrossTrackPointing)"/></Literal>
									</PropertyIsGreaterThanOrEqualTo>
									<PropertyIsLessThanOrEqualTo>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::acrossTrackPointingLowerBound']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="normalize-space(used_acrossTrackPointing)"/></Literal>
									</PropertyIsLessThanOrEqualTo>
								</xsl:if>
							
								<!-- alongTrackPointing  parameter -->
								<xsl:if test="used_alongTrackPointing != ''">
									<PropertyIsGreaterThanOrEqualTo>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::alongTrackPointingUpperBound']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="normalize-space(used_alongTrackPointing)"/></Literal>
									</PropertyIsGreaterThanOrEqualTo>
									<PropertyIsLessThanOrEqualTo>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::alongTrackPointingLowerBound']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="normalize-space(used_alongTrackPointing)"/></Literal>
									</PropertyIsLessThanOrEqualTo>
								</xsl:if>
							
								<!-- nadirSwathWidth parameter -->
								<xsl:if test="used_nadirSwathWidth != ''">
									<PropertyIsEqualTo>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::nadirSwathWidth']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="normalize-space(used_nadirSwathWidth)"/></Literal>
									</PropertyIsEqualTo>
								</xsl:if>
								
								<!-- mass parameter -->
								<xsl:if test="used_mass != ''">
									<PropertyIsEqualTo>
										<PropertyName>$sensor/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-Sensor::mass']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="normalize-space(used_mass)"/></Literal>
									</PropertyIsEqualTo>
								</xsl:if>
							
								<!-- SensorType parameter -->								
								<xsl:if test="used_sensorType != ''">
									<PropertyIsEqualTo>
										<PropertyName>$sensor/@id</PropertyName>
										<PropertyName>$classSensorType/@classifiedObject</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>$classNodeSensorType/@id</PropertyName>
										<PropertyName>$classSensorType/@classificationNode</PropertyName>
									</PropertyIsEqualTo>
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$classNodeSensorType/Name/LocalizedString/@value</PropertyName>
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="normalize-space(used_sensorType)"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>	
									<PropertyIsEqualTo>
										<PropertyName>$classNodeSensorType/@parent</PropertyName>
										<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-Sensor::SystemTypes:SensorType:EOInstrumentType</Literal>
									</PropertyIsEqualTo>									
								</xsl:if>						
							</xsl:if>						
							<xsl:if test="typeHidden = 'dataset'">	
								<!-- Version 0.1.10 -->		
								<!--									
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:DataMetadata</Literal> 								
								</PropertyIsEqualTo>
								-->
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DataMetadata</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<PropertyName>/Classification/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Classification/@classificationNode</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC:Dataset</Literal>
								</PropertyIsEqualTo>	
							</xsl:if>
						
							<xsl:if test="typeHidden = 'application'">	
								<!-- Version 0.1.10 -->		
								<!--									
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:DataMetadata</Literal> 								
								</PropertyIsEqualTo>
								-->
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DataMetadata</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<PropertyName>/Classification/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Classification/@classificationNode</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::Application</Literal>
								</PropertyIsEqualTo>	
							</xsl:if>
							<!-- ::::::: -->
							<!-- Service -->
							<!-- ::::::: -->
							<xsl:if test="used_couplingType != ''">
								 <PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<PropertyName>$classCouplingType/@classifiedObject</PropertyName>
								 </PropertyIsEqualTo>
								 <PropertyIsEqualTo>
									<PropertyName>$classCouplingType/@classificationNode</PropertyName>
									<PropertyName>$classNodeCouplingType/@id</PropertyName>
								 </PropertyIsEqualTo>
								 <PropertyIsEqualTo>
									<PropertyName>$classNodeCouplingType/@parent</PropertyName>
									<!--
									Change to meet the newest ICD												
									<Literal>urn:def:ebRIM-ClassificationScheme:CouplingType</Literal>
									-->
									<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-CIM::CouplingType</Literal>											
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classNodeCouplingType/Name/LocalizedString/@value</PropertyName>
									<Literal><xsl:value-of select="used_couplingType" /></Literal>
								</PropertyIsEqualTo>
							</xsl:if>	
							
							<xsl:if test="used_operation != ''">
								<PropertyIsEqualTo>
									<PropertyName>$associationOperation/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOperation/@targetObject</PropertyName>
									<PropertyName>$serviceOperation/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$serviceOperation/@id</PropertyName>
									<PropertyName>$classOperation/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classOperation/@classificationNode</PropertyName>
									<PropertyName>$classNodeOperation/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classNodeOperation/Name/LocalizedString/@value</PropertyName>
									<Literal>HTTPPost</Literal>
								</PropertyIsEqualTo>
								
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$serviceOperation/Name/LocalizedString/@value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_operation"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>										
								</PropertyIsLike>
							</xsl:if>	
							
							<xsl:if test="used_dCP != ''">
								<PropertyIsEqualTo>
									<PropertyName>$classNodeDCP/@parent</PropertyName>
									<!--
									Change to meet the newest ICD	
									<Literal>urn:def:ebRIM-ClassificationScheme:DCPList</Literal>
									-->
									<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-CIM::DCPList</Literal>										
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$associationServiceOperation/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationServiceOperation/@targetObject</PropertyName>
									<PropertyName>$serviceOperationEO/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$serviceOperationEO/@id</PropertyName>
									<PropertyName>$classDCP/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classDCP/@classificationNode</PropertyName>
									<PropertyName>$classNodeDCP/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$classNodeDCP/Name/LocalizedString/@value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_dCP"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>	
								</PropertyIsLike>
							</xsl:if>
							
							<xsl:if test="used_serviceType != ''">
								<PropertyIsEqualTo>
									<PropertyName>$class4ServiceType/@classificationNode</PropertyName>
									<PropertyName>$classNode4ServiceType/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$class4ServiceType/@classifiedObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$classNode4ServiceType/@code</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_serviceType"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>	
								</PropertyIsLike>
							</xsl:if>
							
							<xsl:if test="used_serviceTypeVer != ''">
								<PropertyIsEqualTo>
									<PropertyName>$class4ServiceTypeVer/@classificationNode</PropertyName>
									<PropertyName>$classNode4ServiceTypeVer/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$class4ServiceTypeVer/@classifiedObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$classNode4ServiceTypeVer/Description/LocalizedString/@value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_serviceTypeVer"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>	
								</PropertyIsLike>
							</xsl:if>
													
							<xsl:if test="used_operateOn != ''">	
								<PropertyIsEqualTo>
									<PropertyName>$Metadata4Operation/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DataMetadata</Literal>
								</PropertyIsEqualTo>
		
								<PropertyIsEqualTo>
									<PropertyName>$association4OperationOn/@associationType</PropertyName>
									<Literal>urn:x-ionic:internal-identifier:AssociationType:OperatesOn</Literal>										      
								</PropertyIsEqualTo>							
								<PropertyIsEqualTo>							
									<PropertyName>$association4OperationOn/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>							
								<PropertyIsEqualTo>
									<PropertyName>$association4OperationOn/@targetObject</PropertyName>
									<PropertyName>$Metadata4Operation/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>										
									<PropertyName>$associatiDataset/@sourceObject</PropertyName>										
									<PropertyName>$Metadata4Operation/@id</PropertyName>								
								</PropertyIsEqualTo>																		
								<PropertyIsEqualTo>										
									<PropertyName>$associatiDataset/@targetObject</PropertyName>		
									<PropertyName>$metadata/@id</PropertyName>		
								</PropertyIsEqualTo>							
								
								<PropertyIsEqualTo>
									<PropertyName>$metadata/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$metadata/rim:Slot[@name="urn:def:slot:OGC-CSW-ebRIM-CIM::identifier"]/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_operateOn"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							<!-- ::::::::::: -->
							<!-- Not Service -->
							<!-- ::::::::::: -->
															
							<xsl:if test="used_topicCategory != ''">	
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<PropertyName>$classTopic/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$classNodeTopic/@id</PropertyName>
									<PropertyName>$classTopic/@classificationNode</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$classTopic/@classificationScheme</PropertyName>											
									<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-CIM::TopicCategoryCode</Literal>
								</PropertyIsEqualTo>
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$classNodeTopic/@code</PropertyName>										
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_topicCategory"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							
							<!-- Keyword url for the ontology  keyword and subject-->
							<xsl:if test="used_keyword != '' or used_subject !=''">												
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<PropertyName>$classKeyWordUrl/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classNodeKeyWordUrl/@id</PropertyName>
									<PropertyName>$classKeyWordUrl/@classificationNode</PropertyName>
								</PropertyIsEqualTo>
								<xsl:choose>
									<xsl:when test="contains(used_keyword,';') or contains(used_subject,';')">
										<Or>
											<xsl:call-template name="createQueries">
												<xsl:with-param name="keywordUris" select="used_subject"/>
												<xsl:with-param name="slotName">$classNodeKeyWordUrl/@code</xsl:with-param>
											</xsl:call-template>
											<xsl:choose>
												<xsl:when test="normalize-space($keywordURISupported)='yes'">	
													<xsl:choose>
														 <xsl:when test="starts-with(normalize-space(used_keyword),'http://')">				 													 
														<xsl:call-template name="createQueries">
															<xsl:with-param name="keywordUris" select="used_keyword"/>
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/rim:Slot[@name="urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::url"]/rim:ValueList/rim:Value[1]</xsl:with-param>															
														</xsl:call-template>
														  </xsl:when>
														  <xsl:otherwise>
															<xsl:call-template name="createQueries">
															<xsl:with-param name="keywordUris" select="used_keyword"/>
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/@code</xsl:with-param>
														</xsl:call-template>
														</xsl:otherwise>
													</xsl:choose>													
												</xsl:when>
												<xsl:otherwise>
														<xsl:call-template name="createQueries">
															<xsl:with-param name="keywordUris" select="used_keyword"/>
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/@code</xsl:with-param>
														</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>													
										</Or>	
									</xsl:when>
									<xsl:otherwise>
											<xsl:call-template name="createQueries">
												<xsl:with-param name="keywordUris" select="used_subject"/>
												<xsl:with-param name="slotName">$classNodeKeyWordUrl/@code</xsl:with-param>
											</xsl:call-template>				
											<xsl:choose>
												<xsl:when test="normalize-space($keywordURISupported)='yes'">	
													<xsl:choose>
														 <xsl:when test="starts-with(normalize-space(used_keyword),'http://')">				 													 
														<xsl:call-template name="createQueries">
															<xsl:with-param name="keywordUris" select="used_keyword"/>
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/rim:Slot[@name="urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::url"]/rim:ValueList/rim:Value[1]</xsl:with-param>															
														</xsl:call-template>
														  </xsl:when>
														  <xsl:otherwise>
															<xsl:call-template name="createQueries">
															<xsl:with-param name="keywordUris" select="used_keyword"/>
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/@code</xsl:with-param>
														</xsl:call-template>
														</xsl:otherwise>
													</xsl:choose>													
												</xsl:when>
												<xsl:otherwise>
														<xsl:call-template name="createQueries">
															<xsl:with-param name="keywordUris" select="used_keyword"/>
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/@code</xsl:with-param>
														</xsl:call-template>
												</xsl:otherwise>
											</xsl:choose>													
									</xsl:otherwise>
								</xsl:choose>																																		
							</xsl:if>			
							
							<xsl:if test="used_keywordType != ''">	
								<PropertyIsEqualTo>											
									<PropertyName>$classKeyWordType/@classifiedObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$classKeyWordType/@id</PropertyName>
									<PropertyName>$classKeyWordScheme/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								
								<Or>
									<And>
										<PropertyIsEqualTo>											
											<PropertyName>$classKeyWordScheme/@classificationNode</PropertyName>
											<PropertyName>$classKeyWordSchemeNode/@id</PropertyName>																						
										</PropertyIsEqualTo>
								
										<!-- Implement for ERADS -->
										<PropertyIsEqualTo>
											<PropertyName>$classKeyWordScheme/@classificationScheme</PropertyName>																						
											<!--
												Change to meet the newest ICD	
												<Literal>urn:def:ebRIM-ClassificationScheme:KeywordTypeCode</Literal>											
											-->
											<Literal>urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-CIM::KeywordType</Literal>											
										</PropertyIsEqualTo>
										
										<PropertyIsLike escapeChar="!" singleChar="?" wildCard="*">
											<PropertyName>$classKeyWordSchemeNode/Name/LocalizedString/@value</PropertyName>
											<Literal><xsl:call-template name="surroundString">
													<xsl:with-param name="string" select="used_keywordType"/>
													<xsl:with-param name="surroundChar">*
															</xsl:with-param>
												</xsl:call-template></Literal>
										</PropertyIsLike>					
									</And>
									
									<And>
										<!--
											Implement for INTECS
										-->
										<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
											<PropertyName>$classKeyWordType/@classificationNode</PropertyName>										
											<Literal>
												<xsl:call-template name="surroundString">
													<xsl:with-param name="string" select="used_keywordType"/>
													<xsl:with-param name="surroundChar">*
															</xsl:with-param>
												</xsl:call-template>
											</Literal>
										</PropertyIsLike>
										<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
											<PropertyName>$classKeyWordType/@classificationNode</PropertyName>										
											<Literal>*urn:ogc:def:classificationScheme:OGC-CSW-ebRIM-CIM::KeywordType*</Literal>
										</PropertyIsLike>
									</And>
								</Or>
							</xsl:if>
							<!-- End :Section search for keyword and keywordType-->
							
							<xsl:if test="used_organisationName != ''">									
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationMetadataInfo/@sourceObject</PropertyName>
									<PropertyName>$metadataInfoOrganization/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationMetadataInfo/@targetObject</PropertyName>
									<PropertyName>/Organization/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationrim:ExtrinsicObject/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationrim:ExtrinsicObject/@targetObject</PropertyName>
									<PropertyName>$metadataInfoOrganization/@id</PropertyName>
								</PropertyIsEqualTo>
																
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/Organization/Name/LocalizedString/@value</PropertyName>
									
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_organisationName"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							<!-- End :Section search for Organization -->
							
							<!-- take title queryable into account -->								
							<xsl:if test="used_title != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/Name/LocalizedString/@value</PropertyName>														  
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_title"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							
							<!-- take abstract queryable into account -->								
							<xsl:if test="used_abstract != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Description/LocalizedString/@value</PropertyName>														  
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_abstract"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
															
							<xsl:if test="used_language != ''">
								<PropertyIsEqualTo>
									<PropertyName>/Association/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>/Association/@targetObject</PropertyName>
									<PropertyName>$metadata/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$metadata/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">										
									<PropertyName>$metadata/rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value</PropertyName>														  
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_language"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							
							<!-- this is for format -->
							<xsl:if test="used_format != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='format']/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_format"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							
							<!-- Start Date and Stop date for CIM -->
							<xsl:if test="typeHidden != 'instrument'">																				
								<!-- CreationDate > StartDate -->
								<xsl:if test="(used_startDate != '')">								
									<PropertyIsGreaterThanOrEqualTo>										
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value[1]</PropertyName>
										<Literal><xsl:value-of select="used_startDate"/>T00:00:00.000</Literal>
									</PropertyIsGreaterThanOrEqualTo>
								</xsl:if>	
		
								<!-- CreationDate < EndDate -->
								<xsl:if test="(used_startDate != '')">								
									<PropertyIsLessThanOrEqualTo>										
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value[1]</PropertyName>
										<Literal><xsl:value-of select="used_endDate"/>T23:59:59.000</Literal>
									</PropertyIsLessThanOrEqualTo>
								</xsl:if>
							</xsl:if> 	

							
							<!-- this is for publish date -->
							<xsl:if test="(used_publicYear != '')">
								<PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:def:slot:OGC-CSW-ebRIM-CIM::PublicationDate']/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:value-of select="used_publicYear"/>-<xsl:value-of select="used_publicMonth"/>-<xsl:value-of select="used_publicDay"/>T00:00:00.000</Literal>
								</PropertyIsGreaterThanOrEqualTo>									
							</xsl:if>
							
							<!-- this is for creation date -->
							<xsl:if test="(used_modifiedYear != '')">
							   
							  <PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:def:slot:OGC-CSW-ebRIM-CIM::modified']/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:value-of select="used_modifiedYear"/>-<xsl:value-of select="used_modifiedMonth"/>-<xsl:value-of select="used_modifiedDay"/>T00:00:00.000</Literal>
								</PropertyIsGreaterThanOrEqualTo>									
							</xsl:if>
							<!-- this is for alter title -->
							<xsl:if test="used_alternateTitle != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:def:slot:OGC-CSW-ebRIM-CIM::title']/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_alternateTitle"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
															
							<xsl:if test="used_datasetLanguage != ''">
								<PropertyIsEqualTo>
									<PropertyName>/Association/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>/Association/@targetObject</PropertyName>
									<PropertyName>$metadata/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$metadata/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">										
									<PropertyName>$metadata/rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value</PropertyName>														  
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_datasetLanguage"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
															
							<xsl:if test="used_parentIdentifier != ''">		
								<PropertyIsEqualTo>
									<PropertyName>/Association/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>/Association/@targetObject</PropertyName>
									<PropertyName>$metadata/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$metadata/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$metadata/rim:Slot[@name="urn:def:slot:OGC-CSW-ebRIM-CIM::identifier"]/rim:ValueList/rim:Value[1]</PropertyName>										
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_parentIdentifier"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>								
							</xsl:if>
							
							<xsl:if test="used_fileIdentifier != ''">					
								<PropertyIsEqualTo>
									<PropertyName>/Association/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>/Association/@targetObject</PropertyName>
									<PropertyName>$metadata/@id</PropertyName>
								</PropertyIsEqualTo>
								
								<PropertyIsEqualTo>
									<PropertyName>$metadata/@objectType</PropertyName>
									<Literal>urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								<xsl:if test="used_fileIdentifier != ''">							
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$metadata/rim:Slot[@name="urn:def:slot:OGC-CSW-ebRIM-CIM::identifier"]/rim:ValueList/rim:Value[1]</PropertyName>										
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_fileIdentifier"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>								
						</xsl:if>
						
							<xsl:if test="used_geoDesCode != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="coverage"]/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_geoDesCode"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
												
							<xsl:if test="used_distanceVal != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="distance"]/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_distanceVal"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
						
							<xsl:if test="used_distanceUOM != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="distanceUOM"]/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_distanceUOM"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
						
							<xsl:if test="used_denominator != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="denominator"]/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_denominator"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
						
							<xsl:if test="used_geoDesCode != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="coverage"]/rim:ValueList/rim:Value[1]</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_geoDesCode"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
																
							<xsl:if test="used_identifier != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_identifier"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							
							<xsl:if test="(used_tempExtBegin != '')">
								<PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:def:slot:OGC-CSW-ebRIM-CIM::temporal']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:value-of select="used_tempExtBegin" />T00:00:00.000
									</Literal>
								</PropertyIsGreaterThanOrEqualTo>
							</xsl:if>
							
							<xsl:if test="(used_tempExtEnd != '')">
								<PropertyIsLessThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:def:slot:OGC-CSW-ebRIM-CIM::temporal']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:value-of select="used_tempExtEnd" />T23:59:59.000
									</Literal>
								</PropertyIsLessThanOrEqualTo>
							</xsl:if>
													
							<!-- Multi Parent identifier -->								
							<xsl:if test="typeHidden = 'dataset'">
								<xsl:if test="$numOfCollection &gt; 1">
									<Or>										
										<xsl:for-each select="collectionId">												
											<PropertyIsEqualTo>
												<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="urn:def:slot:OGC-CSW-ebRIM-CIM::identifier"]/rim:ValueList/rim:Value[1]</PropertyName>
												<Literal><xsl:value-of select="." /></Literal>
											 </PropertyIsEqualTo>
										</xsl:for-each>																											
									</Or>
								</xsl:if>
							</xsl:if>
							
							<!-- One Parent identifier -->															
							<xsl:if test="typeHidden = 'dataset'">
								<xsl:if test="$numOfCollection = 1">																		
									<xsl:for-each select="collectionId">										
										<PropertyIsEqualTo>
											<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="urn:def:slot:OGC-CSW-ebRIM-CIM::identifier"]/rim:ValueList/rim:Value[1]</PropertyName>
											<Literal><xsl:value-of select="." /></Literal>
										 </PropertyIsEqualTo>
									</xsl:for-each>																		
								</xsl:if>
							</xsl:if>
																				
							<xsl:if test="(used_hasSecurityConstraint != 'false')"> 
								<PropertyIsEqualTo>
									<PropertyName>$associationSecurity/@sourceObject</PropertyName>
									<PropertyName>$metadataInfoSecurity/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationSecurity/@targetObject</PropertyName>
									<PropertyName>/SecurityConstraints/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Association/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Association/@targetObject</PropertyName>
									<PropertyName>$metadataInfoSecurity/@id</PropertyName>
								</PropertyIsEqualTo>
							</xsl:if>							
							
							<xsl:if test="typeHidden != 'instrument'">																				
								<xsl:if test="//aoi:AreaOfInterest/gml:featureMembers/aoi:Feature/gml:boundedBy/gml:Envelope != ''">																																					
									<BBOX>
										<!--	
										old code supported by ERDAS
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']/wrs:ValueList/wrs:AnyValue</PropertyName>
										-->	
										<!--	new code supported by INTECS -->
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue</PropertyName>
									</BBOX>
								</xsl:if>
							</xsl:if>
						</And>
					</Filter>
				</Constraint>
			</Query>
		</GetRecords>
	</xsl:template>
	
	<xsl:template match="serviceNS:sendPresentInput" mode="XML">

		<csw:GetRecordById xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
			service="CSW" version="2.0.1"
			xmlns="http://www.opengis.net/cat/csw/2.0.2">
			<csw:Id>
				<xsl:value-of select="productId" />
			</csw:Id>
			<csw:ElementSetName>full</csw:ElementSetName>
		</csw:GetRecordById>
	</xsl:template>




	<!-- ***************************************************************************
		Templates used to process service Search information
		hma:multiSearchOutput
		
		<xsl:for-each select="./*" >
		<h1>Coucou <xsl:value-of select="name()"/> : <xsl:value-of select="."/></h1>
		</xsl:for-each>
		
		<h1>Sam <xsl:value-of select="./sse:statusInfo/sse:statusId"/></h1>
		*************************************************************************** !-->
	<!-- Default HTML template of the getSearchOutput node. -->


	<xsl:template name="createQueries">
		<xsl:param name="keywordUris"/>
		<xsl:param name="slotName"/>
		<xsl:variable name="left">
			<xsl:value-of select="substring-after($keywordUris, ';')"/>
		</xsl:variable>					
				 <xsl:choose>
					<xsl:when test="contains($keywordUris,';')">
						<ogc:PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
							<ogc:PropertyName><xsl:value-of select="$slotName"/></ogc:PropertyName>
							<ogc:Literal>*<xsl:value-of select="substring-before($keywordUris, ';')"/>*</ogc:Literal>
						</ogc:PropertyIsLike>
						<xsl:call-template name="createQueries">
							<xsl:with-param name="keywordUris" select="$left"/>
							<xsl:with-param name="slotName" select="$slotName"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="normalize-space($keywordUris) != ''">
							<ogc:PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
								<ogc:PropertyName><xsl:value-of select="$slotName"/></ogc:PropertyName>
								<ogc:Literal>*<xsl:value-of select="$keywordUris"/>*</ogc:Literal>
							</ogc:PropertyIsLike>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
	</xsl:template>
</xsl:stylesheet>

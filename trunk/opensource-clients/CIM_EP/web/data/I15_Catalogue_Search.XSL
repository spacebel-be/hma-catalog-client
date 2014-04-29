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
	<xsl:import href="./icd/ogc-13-084r1/ogc-13-084r1-v10-csw-v202-catalogue.xsl"/>
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
				********************************************************* -->
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
			<input type="string" name="used_organisationName#any" />
			<input type="string" name="used_abstract#collection" />
			<input type="string" name="used_subject#collection" />	
			<input type="string" name="used_organisationName#collection" />			
			<input type="string" name="used_abstract#service" />
			<input type="string" name="used_subject#service" />
			<input type="string" name="used_organisationName#service" />
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
			<xsl:if test="typeHidden != 'any'">
				rim:ExtrinsicObject	Classification		
			</xsl:if>				
			<xsl:if test="used_language != '' or used_resourceLanguage != '' or used_parentIdentifier != '' or used_fileIdentifier">
			<!--used_resourceLanguage used_language used_alternateTitle used_parentIdentifier-->
				rim:ExtrinsicObject_metadata Association
			</xsl:if>				
			<xsl:if test="used_keyword != '' or used_subject !=''">			
				Classification_classKeyWordUrl ClassificationNode_classNodeKeyWordUrl
			</xsl:if>					
			<xsl:if test="used_keywordType != ''">				
				Classification_classKeyWordType  Classification_classKeyWordScheme ClassificationNode_classKeyWordSchemeNode
			</xsl:if>							
			<xsl:if test="used_organisationName != ''">
				rim:ExtrinsicObject_metadataInfoOrganization Association_associationOrangization Association_associationOrangizationMetadataInfo rim:Organization_organization
			</xsl:if>			
			<xsl:if test="used_topicCategory != ''">Classification_classTopic ClassificationNode_classNodeTopic</xsl:if>					
			<xsl:if test="used_couplingType != ''">Classification_classCouplingType ClassificationNode_classNodeCouplingType</xsl:if>					
			<xsl:if test="used_hasSecurityConstraint != ''"> 
				rim:ExtrinsicObject_securityConstraints Association_associationSecurity 				
			</xsl:if>
			<xsl:if test="used_operation != ''">
				rim:ExtrinsicObject_serviceOperation Classification_classOperation ClassificationNode_classNodeOperation Association_associationOperation
			</xsl:if>
			<xsl:if test="used_dcp != ''">
				rim:ExtrinsicObject_serviceOperation Classification_classDCP ClassificationNode_classNodeDCP Association_associationOperation   
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
			service="CSW" outputFormat="application/xml" version="2.0.2" resultType="results" outputSchema="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
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
										<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::DataMetadata</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
										<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::DatasetCollection</Literal>
									</PropertyIsEqualTo>
									<PropertyIsEqualTo>
										<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
										<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::ServiceMetadata</Literal>
									</PropertyIsEqualTo>
								</Or>
							</xsl:if>
							
							<!-- Search type Service -->
							<xsl:if test="typeHidden = 'service'">
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>											
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::ServiceMetadata</Literal>													 
								 </PropertyIsEqualTo>
							</xsl:if>	
						
							<xsl:if test="typeHidden = 'collection'">																				
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>											
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::DatasetCollection</Literal>											
								</PropertyIsEqualTo>
							</xsl:if>
								
							<xsl:if test="typeHidden = 'dataset'">											
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::DataMetadata</Literal>
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
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::DataMetadata</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
									<PropertyName>/Classification/@classifiedObject</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>/Classification/@classificationNode</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::Application</Literal>
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
									<Literal>urn:ogc:def:ebRIM-ClassificationScheme:OGC-I15::CouplingType</Literal>											
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
									<PropertyName>$associationOperation/@associationType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-AssociationType:OGC-I15::ContainsOperation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$serviceOperation/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::ServiceOperation</Literal>
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
									
							<xsl:if test="used_dcp != ''">
								<PropertyIsEqualTo>
									<PropertyName>$associationOperation/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOperation/@targetObject</PropertyName>
									<PropertyName>$serviceOperation/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOperation/@associationType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-AssociationType:OGC-I15::ContainsOperation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$serviceOperation/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::ServiceOperation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classDCP/@classifiedObject</PropertyName>
									<PropertyName>$serviceOperation/@id</PropertyName>										
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$classDCP/@classificationNode</PropertyName>
									<PropertyName>$classNodeDCP/@id</PropertyName>										
								</PropertyIsEqualTo>									
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$classNodeDCP/@code</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_dcp"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
										</xsl:call-template>
									</Literal>	
								</PropertyIsLike>
							</xsl:if>
									
							<xsl:if test="used_serviceType != ''">
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$class4ServiceType/@classificationNode</PropertyName>
									<Literal>*urn:ogc:serviceType:<xsl:value-of select="used_serviceType"/>*</Literal>
								</PropertyIsLike>
							</xsl:if>
									
							<xsl:if test="used_serviceTypeVer != ''">
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$class4ServiceTypeVer/@classificationNode</PropertyName>
									<Literal>*urn:ogc:serviceType:*<xsl:value-of select="used_serviceTypeVer"/></Literal>
								</PropertyIsLike>
							</xsl:if>
								
							<xsl:if test="used_operateOn != ''">	
								<PropertyIsEqualTo>
									<PropertyName>$Metadata4Operation/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::DatasetCollection</Literal>
								</PropertyIsEqualTo>

								<PropertyIsEqualTo>
									<PropertyName>$association4OperationOn/@associationType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-AssociationType:OGC-I15::OperatesOn</Literal>										      
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
										<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsLike  wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$metadata/rim:Slot[@name="http://purl.org/dc/elements/1.1/identifier"]/rim:ValueList/rim:Value</PropertyName>
										<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_operateOn"/>
											<xsl:with-param name="surroundChar">*
													</xsl:with-param>
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
									<PropertyName>$classTopic/@classificationNode</PropertyName>											
									<Literal>urn:ogc:def:ebRIM-ClassificationScheme:OGC-I15::TopicCategory:<xsl:value-of select="used_topicCategory"/></Literal>											         
								</PropertyIsEqualTo>
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
																<xsl:with-param name="slotName">$classNodeKeyWordUrl/rim:Slot[@name="http://purl.org/dc/elements/1.1/source"]/rim:ValueList/rim:Value</xsl:with-param>															
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
															<xsl:with-param name="slotName">$classNodeKeyWordUrl/rim:Slot[@name="http://purl.org/dc/elements/1.1/source"]/rim:ValueList/rim:Value</xsl:with-param>															
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
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$classKeyWordType/@classificationNode</PropertyName>										
									<Literal>urn:ogc:def:ebRIM-ClassificationScheme:OGC-I15::KeywordScheme<xsl:value-of select="used_keywordType"/></Literal>
								</PropertyIsLike>										
							</xsl:if>
								
							<xsl:if test="used_organisationName != ''">									
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationMetadataInfo/@sourceObject</PropertyName>
									<PropertyName>$metadataInfoOrganization/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationMetadataInfo/@targetObject</PropertyName>
									<PropertyName>$organization/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangizationMetadataInfo/@associationType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-AssociationType:OGC-I15::MetadataPointOfContact</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangization/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationOrangization/@targetObject</PropertyName>
									<PropertyName>$metadataInfoOrganization/@id</PropertyName>
								</PropertyIsEqualTo>
																
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$organization/rim:Name/LocalizedString/@value</PropertyName>
									
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_organisationName"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
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
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::MetadataInformation</Literal>
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
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/elements/1.1/format']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_format"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
							
							<!-- this is for format -->
							<xsl:if test="used_hierarchyLevelName != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/type']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_hierarchyLevelName"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>								
							<xsl:if test="(used_startDate != '')">												
								<Or>
									<PropertyIsGreaterThanOrEqualTo>										
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:ogc:def:ebRIM-slot:OGC-I15::TemporalEnd']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="used_startDate"/>T00:00:00.000</Literal>
									</PropertyIsGreaterThanOrEqualTo>																	
									<PropertyIsNull>										
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:ogc:def:ebRIM-slot:OGC-I15::TemporalEnd']/rim:ValueList/rim:Value</PropertyName>											
									</PropertyIsNull>
								</Or>
							</xsl:if>		
							<xsl:if test="(used_endDate != '')">							
								<Or>									
									<PropertyIsLessThanOrEqualTo>										
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:ogc:def:ebRIM-slot:OGC-I15::TemporalBegin']/rim:ValueList/rim:Value</PropertyName>
										<Literal><xsl:value-of select="used_endDate"/>T23:59:59.000</Literal>
									</PropertyIsLessThanOrEqualTo>
									<PropertyIsNull>										
										<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:ogc:def:ebRIM-slot:OGC-I15::TemporalBegin']/rim:ValueList/rim:Value</PropertyName>											
									</PropertyIsNull>
								</Or>	
							</xsl:if>	
							<!-- this is for publish date -->
							<xsl:if test="(used_publicationDate != '')">
								<PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/issued']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:value-of select="used_publicationDate"/>T00:00:00.000</Literal>
								</PropertyIsGreaterThanOrEqualTo>									
							</xsl:if>
								
							<!-- this is for creation date -->
							<xsl:if test="(used_modifiedDate != '')">									   
							  <PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/modified]/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:value-of select="used_modifiedDate"/>T00:00:00.000</Literal>
								</PropertyIsGreaterThanOrEqualTo>									
							</xsl:if>
							
							<!-- this is for creation date -->
							<xsl:if test="(used_revisionDate != '')">									   
							  <PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/modified']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:value-of select="used_revisionDate"/>T00:00:00.000</Literal>
								</PropertyIsGreaterThanOrEqualTo>									
							</xsl:if>
								
							<!-- this is for creation date -->
							<xsl:if test="(used_creationDate != '')">									   
							  <PropertyIsGreaterThanOrEqualTo>
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:value-of select="used_creationDate"/>T00:00:00.000</Literal>
								</PropertyIsGreaterThanOrEqualTo>									
							</xsl:if>
								
							<!-- this is for alter title -->
							<xsl:if test="used_alternateTitle != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/terms/title']/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_alternateTitle"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
																
							<xsl:if test="used_resourceLanguage != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">										
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value</PropertyName>														  
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_resourceLanguage"/>
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
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>$metadata/rim:Slot[@name="http://purl.org/dc/elements/1.1/identifier"]/rim:ValueList/rim:Value</PropertyName>										
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
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::MetadataInformation</Literal>
								</PropertyIsEqualTo>
								<xsl:if test="used_fileIdentifier != ''">							
									<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
										<PropertyName>$metadata/rim:Slot[@name="http://purl.org/dc/elements/1.1/identifier"]/rim:ValueList/rim:Value</PropertyName>										
										<Literal>
											<xsl:call-template name="surroundString">
												<xsl:with-param name="string" select="used_fileIdentifier"/>
												<xsl:with-param name="surroundChar">*</xsl:with-param>
											</xsl:call-template>
										</Literal>
									</PropertyIsLike>
								</xsl:if>								
							</xsl:if>
								
							<xsl:if test="used_distanceVal != ''">
								<PropertyIsLike wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="distance"]/rim:ValueList/rim:Value</PropertyName>
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
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="distanceUOM"]/rim:ValueList/rim:Value</PropertyName>
									<Literal>
										<xsl:call-template name="surroundString">
											<xsl:with-param name="string" select="used_distanceUOM"/>
											<xsl:with-param name="surroundChar">*</xsl:with-param>
										</xsl:call-template>
									</Literal>
								</PropertyIsLike>
							</xsl:if>
								
							<xsl:if test="used_denominator != ''">
								<PropertyIsEqualTo wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="urn:ogc:def:ebRIM-slot:OGC-I15::ScaleDenominator"]/rim:ValueList/rim:Value</PropertyName>
									<Literal><xsl:value-of select="used_denominator"/></Literal>
								</PropertyIsEqualTo>
							</xsl:if>
								
							<xsl:if test="used_geoDesCode != ''">
								<PropertyIsEqualTo wildCard="*" singleChar="?" escapeChar="!">
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="http://purl.org/dc/elements/1.1/coverage"]/rim:ValueList/rim:Value</PropertyName>
									<Literal><xsl:value-of select="used_geoDesCode"/></Literal>
								</PropertyIsEqualTo>
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
								
							<!-- Multi Parent identifier -->								
							<xsl:if test="typeHidden = 'dataset'">
								<xsl:if test="$numOfCollection &gt; 1">
									<Or>										
										<xsl:for-each select="collectionId">												
											<PropertyIsEqualTo>
												<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="http://purl.org/dc/elements/1.1/identifier"]/rim:ValueList/rim:Value</PropertyName>
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
											<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name="http://purl.org/dc/elements/1.1/identifier"]/rim:ValueList/rim:Value</PropertyName>
											<Literal><xsl:value-of select="." /></Literal>
										 </PropertyIsEqualTo>
									</xsl:for-each>																		
								</xsl:if>
							</xsl:if>
																
							<xsl:if test="(used_hasSecurityConstraint != 'false' and used_hasSecurityConstraint != '')"> 
								<PropertyIsEqualTo>
									<PropertyName>$securityConstraints/@objectType</PropertyName>
									<Literal>urn:ogc:def:ebRIM-ObjectType:OGC-I15::SecurityConstraints</Literal>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationSecurity/@sourceObject</PropertyName>
									<PropertyName>/rim:ExtrinsicObject/@id</PropertyName>
								</PropertyIsEqualTo>
								<PropertyIsEqualTo>
									<PropertyName>$associationSecurity/@targetObject</PropertyName>
									<PropertyName>$securityConstraints/@id</PropertyName>
								</PropertyIsEqualTo>										
							</xsl:if>
								
							<xsl:if test="//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope != ''">																																					
								<BBOX>											
									<PropertyName>/rim:ExtrinsicObject/rim:Slot[@name='urn:ogc:def:ebRIM-slot:OGC-I15::Envelope']/wrs:ValueList/wrs:AnyValue</PropertyName>
									<xsl:copy-of select="//aoi:AreaOfInterest/gml:featureMember/aoi:Feature/gml:boundedBy/gml:Envelope"/>
								</BBOX>
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

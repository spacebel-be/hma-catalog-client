<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:serviceNs="http://www.spacebel.be/sse"
	xmlns:sse="http://www.esa.int/mass" xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:ows="http://www.opengis.net/ows" xmlns:gmlex="http://www.opengis.net/gml/3.2"
	xmlns:gml="http://www.opengis.net/gml" xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:csw="http://www.opengis.net/cat/csw/2.0.2"
	xmlns:rim="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0" xmlns:wrs="http://www.opengis.net/cat/wrs/1.0"
	xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi"
	xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:swe="http://www.opengis.net/swe/1.0.1"
	xmlns:sensorML="http://www.opengis.net/sensorML/1.0.1">

	<!-- Import statements -->
	<xsl:import href="../../searchResult4EbRim.xsl" />
	<!-- *************************************************************************** 
		Templates used to generate XML input msg for workflow Present *************************************************************************** 
		! -->
	<xsl:template match="serviceNs:sendPresentInput" mode="XML">
		<csw:GetRecordById version="2.0.2" service="CSW"
			outputSchema="urn:oasis:names:tc:ebxml-regrep:xsd:rim:3.0">
			<csw:Id>
				<xsl:value-of select="productId" />
			</csw:Id>
			<csw:ElementSetName typeNames="rim:ExtrinsicObject">
				<xsl:value-of select="presentation" />
			</csw:ElementSetName>
		</csw:GetRecordById>
	</xsl:template>
	<!-- *************************************************************************** 
		Templates used to process service Search information hma:multiSearchOutput 
		*************************************************************************** 
		! -->
	<xsl:template name="sse:viewEmbeddedResult">
		<xsl:param name="pos" />
		<xsl:param name="result" />
		<xsl:param name="type" />
	</xsl:template>

	<!-- *************************************************************************** 
		Templates used to display search and present Metadata *************************************************************************** 
		! -->
	<!-- Template matches response from workflow -->
	<xsl:template match="serviceNs:portalMetadata">
		<xsl:choose>
			<xsl:when
				test="starts-with(string(../../serviceNs:retrievedData/@presentation) ,'summary')">
				<xsl:if test="rim:ExtrinsicObject">
					<xsl:for-each select="rim:ExtrinsicObject">
						<xsl:call-template name="serviceNs:portalMetadataSummary4rim">
							<xsl:with-param name="self" select="." />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="wrs:ExtrinsicObject">
					<xsl:for-each select="wrs:ExtrinsicObject">
						<xsl:call-template name="serviceNs:portalMetadataSummary4wrs">
							<xsl:with-param name="self" select="." />
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="./gmi:MI_Metadata">
						<xsl:for-each select="./gmi:MI_Metadata">
							<xsl:call-template name="serviceNs:portalMetadataFull">
								<xsl:with-param name="self" select="./gmi:MI_Metadata" />
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:when test="./gmd:MD_Metadata">
						<xsl:for-each select="./gmd:MD_Metadata">
							<xsl:call-template name="serviceNs:portalMetadataFull">
								<xsl:with-param name="self" select="./gmd:MD_Metadata" />
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="serviceNs:portalMetadataFull">
							<xsl:with-param name="self" select="." />
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template matches response from workflow (cont) -->
	<xsl:template match="serviceNs:searchOutput">
		<xsl:param name="displayedRecords" />
		<!--xsl:call-template name="serviceNs:getMaxNbrOfItemsTemplate" / -->
		<xsl:variable name="parentId" select="sse:parentId" />
		<xsl:choose>
			<xsl:otherwise>
				<xsl:for-each select="sse:viewEmbeddedResult">
					<xsl:call-template name="sse:viewEmbeddedResult">
						<xsl:with-param name="pos" select="position()" />
						<xsl:with-param name="result" select="./sse:embeddedResult" />
						<xsl:with-param name="type" select="./sse:embeddedType" />
					</xsl:call-template>
				</xsl:for-each>
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
				<xsl:for-each select="serviceNs:retrievedData/serviceNs:portalMetadata">
					<xsl:apply-templates select="." />
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template matches direct response from catalogue -->
	<xsl:template match="csw:SearchResults">
		<xsl:param name="displayedRecords" />
		<!--xsl:call-template name="serviceNs:getMaxNbrOfItemsTemplate" / -->
		<xsl:variable name="parentId" select="sse:parentId" />
		<xsl:choose>
			<xsl:otherwise>
				<xsl:for-each select="sse:viewEmbeddedResult">
					<xsl:call-template name="sse:viewEmbeddedResult">
						<xsl:with-param name="pos" select="position()" />
						<xsl:with-param name="result" select="./sse:embeddedResult" />
						<xsl:with-param name="type" select="./sse:embeddedType" />
					</xsl:call-template>
				</xsl:for-each>
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
				<xsl:for-each select="wrs:ExtrinsicObject[@objectType='urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DataMetadata']">
					<xsl:choose>
						<xsl:when test="../../../csw:GetRecordsResponse">
							<xsl:call-template name="serviceNs:portalMetadataSummary4wrs">
								<xsl:with-param name="self" select="." />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="wrs:ExtrinsicObject[@objectType='urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DatasetCollection']">
					<xsl:choose>
						<xsl:when test="../../../csw:GetRecordsResponse">
							<xsl:call-template name="serviceNs:portalMetadataSummary4wrs">
								<xsl:with-param name="self" select="." />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="wrs:ExtrinsicObject[@objectType='urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::ServiceMetadata']">
					<xsl:choose>
						<xsl:when test="../../../csw:GetRecordsResponse">
							<xsl:call-template name="serviceNs:portalMetadataSummary4wrs">
								<xsl:with-param name="self" select="." />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<xsl:for-each select="rim:ExtrinsicObject[@objectType='urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DataMetadata']">
					<xsl:choose>
						<xsl:when test="../../../csw:GetRecordsResponse">
							<xsl:call-template name="serviceNs:portalMetadataSummary4rim">
								<xsl:with-param name="self" select="." />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>					
				</xsl:for-each>
				<xsl:for-each select="rim:ExtrinsicObject[@objectType='urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::DatasetCollection']">
					<xsl:choose>
						<xsl:when test="../../../csw:GetRecordsResponse">
							<xsl:call-template name="serviceNs:portalMetadataSummary4rim">
								<xsl:with-param name="self" select="." />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>					
				</xsl:for-each>
				<xsl:for-each select="rim:ExtrinsicObject[@objectType='urn:ogc:def:objectType:OGC-CSW-ebRIM-CIM::ServiceMetadata']">
					<xsl:choose>
						<xsl:when test="../../../csw:GetRecordsResponse">
							<xsl:call-template name="serviceNs:portalMetadataSummary4rim">
								<xsl:with-param name="self" select="." />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>					
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template for rim -->
	<xsl:template name="serviceNs:portalMetadataSummary4rim">
		<xsl:param name="self" />
		<!--xsl:variable name="parentId" select="normalize-space($self/sse:parentId)" 
			/ -->
		<xsl:variable name="parentId"
			select="rim:ExtrinsicObject/rim:Name/rim:LocalizedString/@value" />
		<xsl:variable name="productId" select="rim:ExtrinsicObject/@id" />
		<xsl:variable name="overlap">
			<xsl:choose>
				<xsl:when test="contains($self/sse:overlap, '.')">
					<xsl:value-of select="substring-before($self/sse:overlap,'.')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$self/sse:overlap" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<element productId="{$productId}" parentId="{$parentId}">
			<!--xsl:for-each select="wrs:ExtrinsicObject" -->
			<gmlFeature>
				<gml:featureMember xmlns:gml="http://www.opengis.net/gml">
					<Feature xmlns="http://www.esa.int/xml/schemas/mass/serviceresult">
						<!-- translate(@id,'.:-','___') -->
						<xsl:attribute name="gml:id"><xsl:value-of
							select="@id" /></xsl:attribute>
						<id>
							<xsl:value-of select="@id" />
						</id>
						<tooltip>
							<xsl:value-of select="@id" />
						</tooltip>
						<!--<attribute15>Scene Center,</attribute15> -->
						<xsl:if test="rim:Slot[@name='http://purl.org/dc/terms/spatial']">
							<xsl:variable name="a"
								select="substring-before(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:lowerCorner, ' ')" />
							<xsl:variable name="b"
								select="substring-after(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:lowerCorner, ' ')" />
							<xsl:variable name="c"
								select="substring-before(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:upperCorner, ' ')" />
							<xsl:variable name="d"
								select="substring-after(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:upperCorner, ' ')" />
							<xsl:variable name="space" select="' '" />
							<geometry>
								<Polygon xmlns="http://www.opengis.net/gml" srsName="EPSG:4326">
									<exterior>
										<LinearRing>
											<posList>
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$a" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$a" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$d" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$d" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
											</posList>
										</LinearRing>
									</exterior>
								</Polygon>
							</geometry>
						</xsl:if>
						<xsl:if
							test="rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']">
							<xsl:variable name="a"
								select="substring-before(rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:lowerCorner, ' ')" />
							<xsl:variable name="b"
								select="substring-after(rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:lowerCorner, ' ')" />
							<xsl:variable name="c"
								select="substring-before(rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:upperCorner, ' ')" />
							<xsl:variable name="d"
								select="substring-after(rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:upperCorner, ' ')" />
							<xsl:variable name="space" select="' '" />
							<geometry>
								<Polygon xmlns="http://www.opengis.net/gml" srsName="EPSG:4326">
									<exterior>
										<LinearRing>
											<posList>
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$a" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$a" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$d" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$d" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
											</posList>
										</LinearRing>
									</exterior>
								</Polygon>
							</geometry>
						</xsl:if>
					</Feature>
				</gml:featureMember>
			</gmlFeature>
			<xsl:variable name="id" select="./@id" />
			<xsl:if test="./@id != ''">
				<property name="Id">
					<xsl:value-of select="./@id" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/identifier']/rim:ValueList/rim:Value != ''">
				<property name="Identifier">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/identifier']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if test="rim:Name/rim:LocalizedString/@value != ''">
				<property name="Name" orderInput="true">
					<xsl:value-of select="rim:Name/rim:LocalizedString/@value" />
				</property>
			</xsl:if>
			<xsl:if test="rim:Description/rim:LocalizedString/@value != ''">
				<property name="Abstract">
					<xsl:value-of select="rim:Description/rim:LocalizedString/@value" />
				</property>
			</xsl:if>
			<xsl:if test="rim:Slot[@name='Type']/rim:ValueList/rim:Value != ''">
				<property name="Type">
					<xsl:value-of select="rim:Description/rim:LocalizedString/@value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/format']/rim:ValueList/rim:Value != ''">
				<property name="Format">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/format']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/terms/references']/rim:ValueList/rim:Value != ''">
				<property name="OnlineResource" orderInput="true">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/terms/references']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value != ''">
				<property name="CreatedDate">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/terms/modified']/rim:ValueList/rim:Value != ''">
				<property name="ModifiedDate">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/terms/modified']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value != ''">
				<property name="Language">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/rights']/rim:ValueList/rim:Value != ''">
				<property name="rights">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/rights']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
		</element>
	</xsl:template>
	<!-- Template for wrs -->
	<xsl:template name="serviceNs:portalMetadataSummary4wrs">
		<xsl:param name="self" />
		<xsl:variable name="parentId" select="rim:Name/rim:LocalizedString/@value" />
		<xsl:variable name="productId" select="@id" />
		<xsl:variable name="overlap">
			<xsl:choose>
				<xsl:when test="contains($self/sse:overlap, '.')">
					<xsl:value-of select="substring-before($self/sse:overlap,'.')" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$self/sse:overlap" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<element productId="{$productId}" parentId="{$parentId}">
			<gmlFeature>
				<gml:featureMember xmlns:gml="http://www.opengis.net/gml">
					<Feature xmlns="http://www.esa.int/xml/schemas/mass/serviceresult">
						<xsl:attribute name="gml:id"><xsl:value-of
							select="@id" /></xsl:attribute>
						<id>
							<xsl:value-of select="@id" />
						</id>
						<tooltip>
							<xsl:value-of select="@id" />
						</tooltip>
						<xsl:if test="rim:Slot[@name='http://purl.org/dc/terms/spatial']">
							<xsl:variable name="a"
								select="substring-before(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:lowerCorner, ' ')" />
							<xsl:variable name="b"
								select="substring-after(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:lowerCorner, ' ')" />
							<xsl:variable name="c"
								select="substring-before(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:upperCorner, ' ')" />
							<xsl:variable name="d"
								select="substring-after(rim:Slot[@name='http://purl.org/dc/terms/spatial']/wrs:ValueList/wrs:AnyValue[1]/gml:Envelope/gml:upperCorner, ' ')" />
							<xsl:variable name="space" select="' '" />
							<geometry>
								<Polygon xmlns="http://www.opengis.net/gml" srsName="EPSG:4326">
									<exterior>
										<LinearRing>
											<posList>
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$a" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$a" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$d" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$d" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$c" />
												<xsl:value-of select="$space" />
												<xsl:value-of select="$b" />
											</posList>
										</LinearRing>
									</exterior>
								</Polygon>
							</geometry>
						</xsl:if>
						<xsl:if
							test="rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']">
							<geometry>
								<xsl:copy-of
									select="rim:Slot[@name='urn:ogc:def:slot:OGC-CSW-ebRIM-CIM::envelope']/wrs:ValueList/wrs:AnyValue[1]/gml:Polygon" />
							</geometry>
						</xsl:if>
					</Feature>
				</gml:featureMember>
			</gmlFeature>
			<xsl:variable name="id" select="./@id" />
			<xsl:if test="./@id != ''">
				<property name="Id">
					<xsl:value-of select="./@id" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/identifier']/rim:ValueList/rim:Value != ''">
				<property name="Identifier">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/identifier']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if test="rim:Name/rim:LocalizedString/@value != ''">
				<property name="Name" orderInput="true">
					<xsl:value-of select="rim:Name/rim:LocalizedString/@value" />
				</property>
			</xsl:if>
			<xsl:if test="rim:Description/rim:LocalizedString/@value != ''">
				<property name="Abstract">
					<xsl:value-of select="rim:Description/rim:LocalizedString/@value" />
				</property>
			</xsl:if>
			<xsl:if test="rim:Slot[@name='Type']/rim:ValueList/rim:Value != ''">
				<property name="Type">
					<xsl:value-of select="rim:Description/rim:LocalizedString/@value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/format']/rim:ValueList/rim:Value != ''">
				<property name="Format">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/format']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/terms/references']/rim:ValueList/rim:Value != ''">
				<property name="OnlineResource" orderInput="true">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/terms/references']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value != ''">
				<property name="CreatedDate">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/terms/created']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/terms/modified']/rim:ValueList/rim:Value != ''">
				<property name="ModifiedDate">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/terms/modified']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value != ''">
				<property name="Language">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/language']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
			<xsl:if
				test="rim:Slot[@name='http://purl.org/dc/elements/1.1/rights']/rim:ValueList/rim:Value != ''">
				<property name="rights">
					<xsl:value-of
						select="rim:Slot[@name='http://purl.org/dc/elements/1.1/rights']/rim:ValueList/rim:Value" />
				</property>
			</xsl:if>
		</element>
	</xsl:template>

	<!-- Templates for present -->
	<xsl:template name="serviceNs:portalMetadataFull">
		<xsl:param name="self" />
		<element>
			<xsl:choose>
				<xsl:when test="./gmd:identificationInfo/gmd:MD_DataIdentification">
					<property name="DataType">Collection</property>
				</xsl:when>
				<xsl:when test="./gmd:identificationInfo/srv:SV_ServiceIdentification">
					<property name="DataType">Service</property>
				</xsl:when>
				<xsl:otherwise>
					<property name="DataType">Sensor</property>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="./gmd:dateStamp/gco:Date != ''">
				<property name="Timestamp">
					<xsl:value-of select="./gmd:dateStamp/gco:Date" />
				</property>
			</xsl:if>
			<xsl:if test="./gmd:metadataStandardName/gco:CharacterString != ''">
				<property name="MetadataStandardName">
					<xsl:value-of select="./gmd:metadataStandardName/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if test="./gmd:metadataStandardVersion/gco:CharacterString != ''">
				<property name="MetadataStandardVersion">
					<xsl:value-of select="./gmd:metadataStandardVersion/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:for-each select="./gmd:contact/gmd:CI_ResponsibleParty">
				<xsl:if test="./gmd:role/gmd:CI_RoleCode/@codeListValue != ''">
					<property name="Role">
						<xsl:value-of select="./gmd:role/gmd:CI_RoleCode/@codeListValue " />
					</property>
				</xsl:if>
				<xsl:if test="./gmd:individualName/gco:CharacterString != ''">
					<property name="IndividualName">
						<xsl:value-of select="./gmd:individualName/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if test="./gmd:organisationName/gco:CharacterString != ''">
					<property name="OrganisationName">
						<xsl:value-of select="./gmd:organisationName/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if test="./gmd:positionName/gco:CharacterString != ''">
					<property name="PositionName">
						<xsl:value-of select="./gmd:positionName/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString != ''">
					<property name="ElectronicMail">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint/gco:CharacterString != ''">
					<property name="DeliveryPoint">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:deliveryPoint/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString != ''">
					<property name="City">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString != ''">
					<property name="PostalCode">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country/gco:CharacterString != ''">
					<property name="Country">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country/gco:CharacterString" />
					</property>
				</xsl:if>
			</xsl:for-each>
			<xsl:for-each
				select="./gmd:identificationInfo/*/gmd:pointOfContact/gmd:CI_ResponsibleParty">
				<xsl:if test="./gmd:role/gmd:CI_RoleCode != ''">
					<property name="Role">
						<xsl:value-of select="./gmd:role/gmd:CI_RoleCode " />
					</property>
				</xsl:if>
				<xsl:if test="./gmd:individualName/gco:CharacterString != ''">
					<property name="IndividualName">
						<xsl:value-of select="./gmd:individualName/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if test="./gmd:organisationName/gco:CharacterString != ''">
					<property name="pointOfContact-OrganisationName">
						<xsl:value-of select="./gmd:organisationName/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if test="./gmd:positionName/gco:CharacterString != ''">
					<property name="PositionName">
						<xsl:value-of select="./gmd:positionName/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString != ''">
					<property name="ElectronicMail">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString != ''">
					<property name="Voice">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:voice/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile/gco:CharacterString != ''">
					<property name="Facsimile">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:phone/gmd:CI_Telephone/gmd:facsimile/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString != ''">
					<property name="pointOfContact-City">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:city/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString != ''">
					<property name="pointOfContact-PostalCode">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:postalCode/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country/gco:CharacterString != ''">
					<property name="pointOfContact-Country">
						<xsl:value-of
							select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:country/gco:CharacterString" />
					</property>
				</xsl:if>
			</xsl:for-each>
			<!-- <xsl:if test="//gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL 
				!= ''"> <property name="OnlineResource"> <xsl:value-of select="//gmd:contactInfo/gmd:CI_Contact/gmd:onlineResource/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" 
				/> </property> </xsl:if> <xsl:for-each select="//gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address"> 
				<xsl:if test="./gmd:deliveryPoint/gco:CharacterString != ''"> <property name="DeliveryPoint"> 
				<xsl:value-of select="./gmd:deliveryPoint/gco:CharacterString" /> </property> 
				</xsl:if> </xsl:for-each> -->
			<!-- ::::::::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Identification Information -->
			<!-- ::::::::::::::::::::::::::::::::::: -->
			<!--BEGIN: Ebrim check valid queryable -->
			<xsl:if test="./sse:id != ''">
				<property name="id">
					<!-- <xsl:value-of select="./sse:id"/> -->
					<xsl:value-of select="substring-after(./sse:id,':::::')" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString != ''">
				<property name="Title">
					<xsl:value-of
						select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/*/gmd:abstract/gco:CharacterString != ''">
				<property name="Abstract">
					<xsl:value-of
						select="./gmd:identificationInfo/*/gmd:abstract/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/*/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue != ''">
				<property name="DateType">
					<xsl:value-of
						select="./gmd:identificationInfo/*/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/*/gmd:topicCategory/gmd:MD_TopicCategoryCode != ''">
				<property name="TopicCategory">
					<xsl:value-of
						select="./gmd:identificationInfo/*/gmd:topicCategory/gmd:MD_TopicCategoryCode" />
				</property>
			</xsl:if>
			<!-- :::::::::::::::::: -->
			<!-- :: DataMetadata :: -->
			<!-- :::::::::::::::::: -->
			<xsl:if
				test="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue != 'service'">
				<xsl:if
					test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose/gco:CharacterString != ''">
					<property name="Purpose">
						<xsl:value-of
							select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:purpose/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:EX_GeographicExtend/gmd:EX_GeographicDescription/gmd:GeographicIdentifier/gmd:code != ''">
					<property name="GeographicDescription">
						<xsl:value-of
							select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:EX_GeographicExtend/gmd:EX_GeographicDescription/gmd:GeographicIdentifier/gmd:code" />
					</property>
				</xsl:if>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:dateType/gmd:CI_DateTypeCode/@codeListValue = 'creation'">
				<xsl:if
					test="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date != ''">
					<property name="Created">
						<xsl:call-template name="joinString">
							<xsl:with-param name="stringList"
								select="./gmd:identificationInfo/*/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:Date" />
							<xsl:with-param name="separator">
								,
							</xsl:with-param>
						</xsl:call-template>
					</property>
				</xsl:if>
			</xsl:if>
			
			<xsl:if test="./gmd:language">
				<property name="Language">					
					<xsl:choose>
						<xsl:when test="./gmd:language/gmd:LanguageCode/@codeListValue">							
							<xsl:value-of
								select="./gmd:language/gmd:LanguageCode/@codeListValue" />							
						</xsl:when>
						<xsl:when test="./gmd:language/gco:CharacterString">							
							<xsl:value-of
								select="./gmd:language/gco:CharacterString" />							
						</xsl:when>
					</xsl:choose>
				</property>
			</xsl:if>
			
			<xsl:if
				test="./gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue  != ''">
				<property name="CharacterSet">
					<xsl:value-of
						select="./gmd:characterSet/gmd:MD_CharacterSetCode/@codeListValue" />
				</property>
			</xsl:if>			
			<!-- Just for DataMetaData -->
			<!--xsl:if test="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue 
				= 'series' or ./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'dataset'" -->
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
				<xsl:variable name="westLongitude"
					select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:westBoundLongitude" />
				<xsl:variable name="southLatitude"
					select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:southBoundLatitude" />
				<xsl:variable name="eastLongitude"
					select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:eastBoundLongitude" />
				<xsl:variable name="northLatitude"
					select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox/gmd:northBoundLatitude" />
				<property name="NorthLatitude">
					<xsl:value-of select="$northLatitude" />
				</property>
				<property name="SouthLatitude">
					<xsl:value-of select="$southLatitude" />
				</property>
				<property name="EastLongitude">
					<xsl:value-of select="$eastLongitude" />
				</property>
				<property name="WestLongitude">
					<xsl:value-of select="$westLongitude" />
				</property>
			</xsl:if>
			<xsl:for-each select="./gmd:identificationInfo/*/gmd:descriptiveKeywords">
				<xsl:for-each select="./gmd:MD_Keywords/gmd:keyword">
					<group name="KeywordGroup">
						<property name="ThesaurusName">
							<xsl:value-of select="../gmd:thesaurusName/gmd:CI_Citation/gmd:title" />
						</property>
						<property name="ThesaurusURI">
							<xsl:value-of select="../gmd:thesaurusName/gmd:CI_Citation/gmd:title/gmx:Anchor/@xlink:href" />
						</property>
						<property name="KeywordType">
							<xsl:value-of select="../gmd:type/gmd:MD_KeywordTypeCode/@codeListValue" />
						</property>
						<xsl:choose>
							<xsl:when test="./gmx:Anchor != ''">
								<property name="Keyword">
									<xsl:value-of select="./gmx:Anchor" />
								</property>
								<property name="KeywordURI">
									<xsl:value-of select="./gmx:Anchor/@xlink:href" />
								</property>
							</xsl:when>
							<xsl:otherwise>
								<property name="Keyword">
									<xsl:value-of select="." />
								</property>
							</xsl:otherwise>
						</xsl:choose>

					</group>
				</xsl:for-each>
			</xsl:for-each>
			<!-- :::::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Constraints Information -->
			<!-- :::::::::::::::::::::::::::::::: -->
			<xsl:for-each select="./gmd:identificationInfo/*/gmd:resourceConstraints">
				<xsl:if
					test="./gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString != ''">
					<property name="LimitationConstraints">
						<xsl:value-of
							select="./gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode  != ''">
					<property name="AccessConstraints">
						<xsl:value-of
							select="./gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString  != ''">
					<property name="OtherConstraints">
						<xsl:value-of
							select="./gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString" />
					</property>
				</xsl:if>
			</xsl:for-each>
			<!-- :::::::::::::::::::::::::::::: -->
			<!-- END: Constraints Information -->
			<!-- :::::::::::::::::::::::::::::: -->
			<!-- ::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Resource Information -->
			<!-- ::::::::::::::::::::::::::::: -->
			<!--BEGIN: Ebrim check valid queryable -->
			<xsl:if test="./gmd:fileIdentifier/gco:CharacterString != ''">
				<property name="FileIdentifier">
					<xsl:value-of select="./gmd:fileIdentifier/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString != ''">
				<property name="Identifier">
					<xsl:value-of
						select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:code/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:codeSpace/gco:CharacterString != ''">
				<property name="CodeSpace">
					<xsl:value-of
						select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/*/gmd:codeSpace/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language != ''">
				<property name="DatasetLanguage">
					<xsl:value-of
						select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language" />
				</property>
			</xsl:if>
			<xsl:if test="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue != ''">
				<property name="HierarchyLevel">
					<xsl:value-of
						select="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue" />
				</property>
			</xsl:if>
			<xsl:if test="./gmd:parentIdentifier/gco:CharacterString != ''">
				<property name="ParentIdentifier">
					<xsl:value-of select="./gmd:parentIdentifier/gco:CharacterString" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gmlex:TimePeriod/gmlex:beginPosition != ''">
				<property name="TemporalBeginPosition">
					<xsl:copy-of
						select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gmlex:TimePeriod/gmlex:beginPosition" />
				</property>
			</xsl:if>
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gmlex:TimePeriod/gmlex:endPosition != ''">
				<property name="TemporalEndPosition">
					<xsl:copy-of
						select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:extent/gmd:EX_Extent/gmd:temporalElement/gmd:EX_TemporalExtent/gmd:extent/gmlex:TimePeriod/gmlex:endPosition" />
				</property>
			</xsl:if>
			<!-- ::::::::::::::::::::::::::: -->
			<!-- END: Resource Information -->
			<!-- ::::::::::::::::::::::::::: -->
			<!-- ::::::::::::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Spatial Resolution Information -->
			<!-- ::::::::::::::::::::::::::::::::::::::: -->
			<xsl:if
				test="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance  != ''">
				<property name="Resolution">
					<xsl:value-of
						select="./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:distance/gco:Distance" />
				</property>
			</xsl:if>
			<!-- ::::::::::::::::::::::::::::::::::::: -->
			<!-- END: Spatial Resolution Information -->
			<!-- ::::::::::::::::::::::::::::::::::::: -->
			<!-- Just for collection -->
			<!-- :::::::::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Related Service Information -->
			<!-- :::::::::::::::::::::::::::::::::::: -->
			<xsl:if
				test="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue != 'service'">
				<xsl:if test="./serviceNs:ServicesInfo">
					<xsl:choose>
						<xsl:when test="./serviceNs:ServicesInfo/serviceNs:ServiceInfo">
							<xsl:for-each select="./serviceNs:ServicesInfo/serviceNs:ServiceInfo">
								<group name="RealtedServiceGroup">
									<property name="ServiceName">
										<xsl:value-of select="./rim:Name/rim:LocalizedString/@value" />
									</property>
									<property name="ServiceId">
										<xsl:value-of select="./serviceNs:id" />
									</property>
								</group>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</xsl:if>
			<!-- :::::::::::::::::::::::::::::::::: -->
			<!-- END: Related Service Information -->
			<!-- :::::::::::::::::::::::::::::::::: -->
			<!-- :::::::::::::::::::::::::::: -->
			<!-- BEGIN: Service Information -->
			<!-- :::::::::::::::::::::::::::: -->
			<xsl:if
				test="./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue = 'service'">
				<xsl:if
					test="./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString != ''">
					<property name="citation-ServiceType">
						<xsl:value-of
							select="./gmd:identificationInfo/srv:SV_ServiceIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:ScopedName != ''">
					<property name="ServiceType">
						<xsl:value-of
							select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceType/gco:ScopedName" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:couplingType/srv:SV_CouplingType  != ''">
					<property name="CouplingType">
						<xsl:value-of
							select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:couplingType/srv:SV_CouplingType" />
					</property>
				</xsl:if>
				<xsl:if
					test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceTypeVersion/gco:CharacterString != ''">
					<property name="Version">
						<xsl:value-of
							select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:serviceTypeVersion/gco:CharacterString" />
					</property>
				</xsl:if>
				<!-- get value Operates On with xlink:href uuidref -->
				<xsl:choose>
					<!-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: -->
					<!-- This case for service has collection operatesOn exists -->
					<!-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: -->
					<xsl:when test="./serviceNs:ServicesInfo/serviceNs:ServiceInfo">
						<xsl:if
							test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn">
							<xsl:for-each
								select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn">
								<xsl:variable name="idCollection"
									select="normalize-space(substring-after(./@xlink:href,'#'))" />
								<xsl:for-each
									select="$self/serviceNs:ServicesInfo/serviceNs:ServiceInfo">
									<xsl:variable name="idCol"
										select="normalize-space(substring-after(./serviceNs:id,':::::'))" />								
									<xsl:if
										test="starts-with($idCol,$idCollection)">								
										<group name="OperatesOnGroup">
											<property name="collection">
												<xsl:value-of
													select="substring-after($idCollection,'urn:ogc:def:EOP:')" />
											</property>
											<property name="collectionValue">
												<xsl:value-of select="$idCollection" />
											</property>
											<property name="collectionId">
												<xsl:value-of select="serviceNs:id"/>
											</property>
										</group>
									</xsl:if>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:if>
					</xsl:when>
					<!-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: -->
					<!-- This case for service has collection operatesOn not exists -->
					<!-- :::::::::::::::::::::::::::::::::::::::::::::::::::::::::: -->
					<xsl:otherwise>
						<xsl:if
							test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn /@uuidref != ''">
							<property name="list_OperatesOn">
								<xsl:value-of
									select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn /@uuidref" />
							</property>
						</xsl:if>
						<!-- get value Operates On with xlink:href attribute -->
						<xsl:if
							test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn /@xlink:href != ''">
							<property name="CouplingType">
								<xsl:value-of
									select="substring-after(./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:operatesOn /@xlink:href,'#')" />
							</property>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:if
					test="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:couplingType/srv:SV_CouplingType/@codeListValue != ''">
					<property name="CouplingType">
						<xsl:value-of
							select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:couplingType/srv:SV_CouplingType/@codeListValue" />
					</property>
				</xsl:if>

				<xsl:for-each
					select="./gmd:identificationInfo/srv:SV_ServiceIdentification/srv:containsOperations/srv:SV_OperationMetadata">
					<group name="OperationsGroup">
						<xsl:if test="./srv:operationName/gco:CharacterString != ''">
							<property name="OperationName">
								<xsl:value-of select="./srv:operationName/gco:CharacterString" />
							</property>
						</xsl:if>
						<xsl:if test="./srv:DCP/srv:DCPList/@codeListValue != ''">
							<property name="DCP">
								<xsl:value-of select="./srv:DCP/srv:DCPList/@codeListValue" />
							</property>
						</xsl:if>
						<xsl:if
							test="./srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL != ''">
							<property name="ConnectPoint">
								<xsl:value-of
									select="./srv:connectPoint/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>

			</xsl:if>
			<!-- :::::::::::::::::::::::::::: -->
			<!-- END: Service Information -->
			<!-- :::::::::::::::::::::::::::: -->
			<!-- ::::::::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Distribution Information -->
			<!-- ::::::::::::::::::::::::::::::::::: -->
			<xsl:if test="./gmd:distributionInfo">
				<xsl:if
					test="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL != ''">
					<property name="OnlineResource">
						<xsl:value-of
							select="./gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" />
					</property>
				</xsl:if>
			</xsl:if>
			<!-- ::::::::::::::::::::::::::::::::::::::: -->
			<!-- END: DistributionInformation -->
			<!-- ::::::::::::::::::::::::::::::::::::::: -->
			<!-- :::::::::::::::::::::::::::::::::::::::::: -->
			<!-- BEGIN: Data Quality Information -->
			<!-- :::::::::::::::::::::::::::::::::::::::::: -->
			<xsl:if test="./gmd:dataQualityInfo">
				<group name="QualityInfoGroup">
					<xsl:if
						test="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:measureIdentification/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString != ''">
						<property name="CodeSpace">
							<xsl:value-of
								select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:measureIdentification/gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString" />
						</property>
					</xsl:if>
					<xsl:if
						test="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString != ''">
						<property name="Title">
							<xsl:value-of
								select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:specification/gmd:CI_Citation/gmd:title/gco:CharacterString" />
						</property>
					</xsl:if>
					<xsl:if
						test="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation/gco:CharacterString != ''">
						<property name="Explanation">
							<xsl:value-of
								select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:explanation/gco:CharacterString" />
						</property>
					</xsl:if>
					<xsl:if
						test="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass/gco:Boolean != ''">
						<property name="Pass">
							<xsl:value-of
								select="./gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:report/gmd:DQ_DomainConsistency/gmd:result/gmd:DQ_ConformanceResult/gmd:pass/gco:Boolean" />
						</property>
					</xsl:if>
				</group>
			</xsl:if>

			<!-- :::::::::::::::::::::::::::::::::::::::::: -->
			<!-- END: Data Quality Information -->
			<!-- :::::::::::::::::::::::::::::::::::::::::: -->


			<!-- :::::::::::::::::::::::::::::::::::::::::: -->
			<!-- SENSORML -->
			<!-- :::::::::::::::::::::::::::::::::::::::::: -->
			<xsl:if test="sensorML:member/sensorML:System">
				<property name="DataType">System</property>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:uniqueID']/sensorML:value != ''">
					<property name="Identifier">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:uniqueID']/sensorML:value " />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:longName']/sensorML:value != ''">
					<property name="LongName">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:longName']/sensorML:value " />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:shortName']/sensorML:value != ''">
					<property name="ShortName">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:shortName']/sensorML:value " />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value != ''">
					<property name="Parent">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value " />
					</property>
					<xsl:choose>
						<xsl:when
							test="contains(sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value,':::::')">
							<property name="ParentLabel">
								<xsl:value-of
									select="substring-after(sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value,':::::')" />
							</property>
						</xsl:when>
						<xsl:otherwise>
							<property name="ParentLabel">
								<xsl:value-of
									select="sensorML:member/sensorML:System/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value" />
							</property>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="sensorML:member/sensorML:System/gml:description != ''">
					<property name="Description">
						<xsl:value-of select="sensorML:member/sensorML:System/gml:description" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:keywords/sensorML:KeywordList != ''">
					<property name="Keywords">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:keywords/sensorML:KeywordList" />
					</property>
				</xsl:if>
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- START: Contact Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:individualName != ''">
					<property name="IndividualName">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:individualName" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:organizationName!= ''">
					<property name="OrganisationName">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:organizationName" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:deliveryPoint != ''">
					<property name="DeliveryPoint">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:deliveryPoint" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:deliveryPoint != ''">
					<property name="City">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:city" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:postalCode!= ''">
					<property name="PostalCode">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:postalCode" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:country!= ''">
					<property name="Country">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:country" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:electronicMailAddress!= ''">
					<property name="ElectronicMail">
						<xsl:value-of
							select="sensorML:member/sensorML:System/sensorML:contact/sensorML:ResponsibleParty/sensorML:contactInfo/sensorML:address/sensorML:electronicMailAddress" />
					</property>
				</xsl:if>

				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- END: Contact Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->


				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- START: Interface Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:interfaces/sensorML:InterfaceList/sensorML:interface">
					<group name="InterfacesGroup">
						<xsl:if test="@name!= ''">
							<property name="InterfaceName">
								<xsl:value-of select="@name" />
							</property>
						</xsl:if>
						<xsl:if
							test="sensorML:InterfaceDefinition/sensorML:serviceLayer/swe:DataRecord/swe:field[@name='urn:ogc:def:interface:OGC:1.0:ServiceURL']/swe:Text/swe:value!= ''">
							<property name="ServiceURL">
								<xsl:value-of
									select="sensorML:InterfaceDefinition/sensorML:serviceLayer/swe:DataRecord/swe:field[@name='urn:ogc:def:interface:OGC:1.0:ServiceURL']/swe:Text/swe:value" />
							</property>
						</xsl:if>
						<xsl:if
							test="sensorML:InterfaceDefinition/sensorML:serviceLayer/swe:DataRecord/swe:field[@name='urn:ogc:def:interface:OGC:1.0:ServiceType']/swe:Text/swe:value!= ''">
							<property name="ServiceType">
								<xsl:value-of
									select="sensorML:InterfaceDefinition/sensorML:serviceLayer/swe:DataRecord/swe:field[@name='urn:ogc:def:interface:OGC:1.0:ServiceType']/swe:Text/swe:value" />
							</property>
						</xsl:if>
						<xsl:if
							test="sensorML:InterfaceDefinition/sensorML:serviceLayer/swe:DataRecord/swe:field[@name='urn:ogc:def:interface:OGC:1.0:ServiceSpecificSensorID']/swe:Text/swe:value!= ''">
							<property name="ServiceSpecificSensor">
								<xsl:value-of
									select="sensorML:InterfaceDefinition/sensorML:serviceLayer/swe:DataRecord/swe:field[@name='urn:ogc:def:interface:OGC:1.0:ServiceSpecificSensorID']/swe:Text/swe:value" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- END: Interface Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- START: Classification Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:classification/sensorML:ClassifierList/sensorML:classifier">
					<group name="ClassificationGroup">
						<xsl:if test="@name!= ''">
							<xsl:if
								test="sensorML:Term/@definition = 'urn:ogc:def:classifier:OGC:1.0:application'">
								<property name="{@name}">
									<xsl:value-of select="sensorML:Term/sensorML:value" />
								</property>
							</xsl:if>
						</xsl:if>

						<xsl:if test="@name!= ''">
							<xsl:if
								test="sensorML:Term/@definition = 'urn:ogc:def:classifier:OGC:1.0:sensorType'">
								<property name="{@name}">
									<xsl:value-of select="sensorML:Term/sensorML:value" />
								</property>
							</xsl:if>
						</xsl:if>

						<xsl:if test="@name!= ''">
							<xsl:if
								test="sensorML:Term/@definition = 'urn:ogc:def:property:OGC:sensorType'">
								<property name="{@name}">
									<xsl:value-of select="sensorML:Term/sensorML:value" />
								</property>
							</xsl:if>
						</xsl:if>

						<xsl:if test="@name!= ''">
							<xsl:if
								test="sensorML:Term/@definition = 'urn:ogc:def:property:OGC:platformType'">
								<property name="{@name}">
									<xsl:value-of select="sensorML:Term/sensorML:value" />
								</property>
							</xsl:if>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- END: Classification Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- START: Outputs Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:outputs/sensorML:OutputList/sensorML:output">
					<group name="OutputsGroup">
						<xsl:if test="@name!= ''">
							<property name="OutputName">
								<xsl:value-of select="@name" />
							</property>
						</xsl:if>
						<xsl:if test="swe:Quantity/swe:uom/@code  != ''">
							<property name="OutputCode">
								<xsl:value-of select="swe:Quantity/swe:uom/@code" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- END: Outputs Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- START: Input Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:inputs/sensorML:InputList/sensorML:input">
					<group name="InputsGroup">
						<xsl:if test="swe:ObservableProperty/@definition!= ''">
							<property name="Input">
								<xsl:value-of select="swe:ObservableProperty/@definition" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->
				<!-- END: Input Information -->
				<!-- :::::::::::::::::::::::::::::::::::::::::: -->

				<!-- ================================================= -->
				<!-- START: Orbit Geometric Characteristics -->
				<!-- ================================================= -->
				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:characteristics[@xlink:role = 'urn:ogc:def:role:CEOS:eop:OrbitCharacteristics']">
					<group name="OrbitCharsGroup">
						<xsl:for-each select="swe:DataRecord/swe:field">
							<xsl:choose>
								<xsl:when test="swe:Quantity">
									<property name="{@name}">
										<xsl:value-of select="swe:Quantity/swe:value" />
										<xsl:value-of select="' '" />
										<xsl:value-of select="swe:Quantity/swe:uom/@code" />
									</property>
								</xsl:when>
								<xsl:when test="swe:Count">
									<property name="{@name}">
										<xsl:value-of select="swe:Count/swe:value" />
									</property>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- START: Orbit Geometric Characteristics -->
				<!-- ================================================= -->

				<!-- ================================================= -->
				<!-- START: Instrument Geometric Characteristics -->
				<!-- ================================================= -->
				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:characteristics[@xlink:role = 'urn:ogc:def:role:CEOS:eop:GeometricCharacteristics']">
					<group name="GeoCharsGroup">
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackFov']/swe:value != ''">
							<property name="AcrossTrackFov">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackFov']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackFov']/swe:uom/@code" />
							</property>
						</xsl:if>
						<xsl:if
							test="swe:DataRecord/swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackPointingRange']/swe:value != ''">
							<property name="AcrossTrackPointingRange">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackPointingRange']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackPointingRange']/swe:uom/@code" />
							</property>
						</xsl:if>
						<xsl:if
							test="swe:DataRecord/swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackPointingRange']/swe:value != ''">
							<property name="AlongTrackPointingRange">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackPointingRange']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackPointingRange']/swe:uom/@code" />
							</property>
						</xsl:if>
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:NadirSwathWidth']/swe:value != ''">
							<property name="NadirSwathWidth">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:NadirSwathWidth']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:NadirSwathWidth']/swe:uom/@code" />
							</property>
						</xsl:if>
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:GroundLocationAccuracy']/swe:value != ''">
							<property name="GroundLocationAccuracy">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:GroundLocationAccuracy']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:GroundLocationAccuracy']/swe:uom/@code" />
							</property>
						</xsl:if>
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:RevisitTime']/swe:value != ''">
							<property name="RevisitTime">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:RevisitTime']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:RevisitTime']/swe:uom/@code" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- END: Instrument Geometric Characteristics -->
				<!-- ================================================= -->

				<!-- ================================================= -->
				<!-- START: Instrument Measurement Characteristics -->
				<!-- ================================================= -->
				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:characteristics[@xlink:role = 'urn:ogc:def:role:CEOS:eop:MeasurementCharacteristics']">
					<group name="MeasCharsGroup">
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Count[@definition='urn:ogc:def:property:CEOS:opt:NumberOfBands']/swe:value != ''">
							<property name="NumberOfBands">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Count[@definition='urn:ogc:def:property:CEOS:opt:NumberOfBands']/swe:value" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- END: Instrument Measurement Characteristics -->
				<!-- ================================================= -->

				<!-- ================================================= -->
				<!-- START: Instrument Physical Characteristics -->
				<!-- ================================================= -->
				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:characteristics[@xlink:role = 'urn:ogc:def:role:CEOS:eop:PhysicalCharacteristics']">
					<group name="PhysicalCharsGroup">
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:OGC:mass']/swe:value != ''">
							<property name="Mass">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:OGC:mass']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:OGC:mass']/swe:uom/@code" />
							</property>
						</xsl:if>
						<xsl:if
							test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:MaximumPowerConsumption']/swe:value != ''">
							<property name="MaximumPowerConsumption">
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:MaximumPowerConsumption']/swe:value" />
								<xsl:value-of select="' '" />
								<xsl:value-of
									select="swe:DataRecord /swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:MaximumPowerConsumption']/swe:uom/@code" />
							</property>
						</xsl:if>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- END: Instrument Physical Characteristics -->
				<!-- ================================================= -->

				<!-- ================================================= -->
				<!-- START: Components -->
				<!-- ================================================= -->
				<xsl:for-each
					select="sensorML:member/sensorML:System/sensorML:components/sensorML:ComponentList/sensorML:component">
					<group name="ComponentsGroup">
						<property name="Component">
							<xsl:value-of select="@name" />
						</property>
						<xsl:choose>
							<xsl:when test="contains(@name,':::::')">
								<property name="ComponentLabel">
									<xsl:value-of select="substring-after(@name,':::::')" />
								</property>
							</xsl:when>
							<xsl:otherwise>
								<property name="ComponentLabel">
									<xsl:value-of select="@name" />
								</property>
							</xsl:otherwise>
						</xsl:choose>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- END: Components -->
				<!-- ================================================= -->
			</xsl:if>
			<xsl:if test="sensorML:member/sensorML:Component">
				<property name="DataType">Component</property>
				<xsl:if
					test="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:uniqueID']/sensorML:value != ''">
					<property name="Identifier">
						<xsl:value-of
							select="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:uniqueID']/sensorML:value " />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:longName']/sensorML:value != ''">
					<property name="LongName">
						<xsl:value-of
							select="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:longName']/sensorML:value " />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:shortName']/sensorML:value != ''">
					<property name="ShortName">
						<xsl:value-of
							select="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:shortName']/sensorML:value " />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value != ''">
					<property name="Parent">
						<xsl:value-of
							select="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value " />
					</property>
					<xsl:choose>
						<xsl:when
							test="contains(sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value,':::::')">
							<property name="ParentLabel">
								<xsl:value-of
									select="substring-after(sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value,':::::')" />
							</property>
						</xsl:when>
						<xsl:otherwise>
							<property name="ParentLabel">
								<xsl:value-of
									select="sensorML:member/sensorML:Component/sensorML:identification/sensorML:IdentifierList/sensorML:identifier/sensorML:Term[@definition='urn:ogc:def:identifier:OGC:1.0:parentSystemUniqueID']/sensorML:value" />
							</property>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<xsl:if test="sensorML:member/sensorML:Component/gml:description != ''">
					<property name="Description">
						<xsl:value-of select="sensorML:member/sensorML:Component/gml:description" />
					</property>
				</xsl:if>
				<xsl:if
					test="sensorML:member/sensorML:Component/sensorML:keywords/sensorML:KeywordList != ''">
					<property name="Keywords">
						<xsl:value-of
							select="sensorML:member/sensorML:Component/sensorML:keywords/sensorML:KeywordList" />
					</property>
				</xsl:if>

				<!-- ================================================= -->
				<!-- START: Detector Measurement Characteristics -->
				<!-- ================================================= -->
				<!-- <xsl:for-each select="sensorML:member/sensorML:Component/sensorML:characteristics[@xlink:role 
					= 'urn:ogc:def:role:CEOS:eop:GeometricCharacteristics']"> <group name="DetectorGeoCharsGroup"> 
					<xsl:if test="swe:DataRecord/swe:field/swe:Quantity [@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackGroundResolution']/swe:value 
					!= ''"> <property name="AcrossTrackGroundResolution"> <xsl:value-of select="swe:DataRecord/swe:field/swe:Quantity 
					[@definition='urn:ogc:def:property:CEOS:eop:AcrossTrackGroundResolution']/swe:value"/> 
					<xsl:value-of select="' '"/> <xsl:value-of select="swe:DataRecord/swe:field/swe:Quantity 
					[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackGroundResolution']/swe:uom/@code"/> 
					</property> </xsl:if> <xsl:if test="swe:DataRecord/swe:field/swe:Quantity 
					[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackGroundResolution']/swe:value 
					!= ''"> <property name="AlongTrackGroundResolution"> <xsl:value-of select="swe:DataRecord/swe:field/swe:Quantity 
					[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackGroundResolution']/swe:value"/> 
					<xsl:value-of select="' '"/> <xsl:value-of select="swe:DataRecord/swe:field/swe:Quantity 
					[@definition='urn:ogc:def:property:CEOS:eop:AlongTrackGroundResolution']/swe:uom/@code"/> 
					</property> </xsl:if> <xsl:if test="swe:DataRecord/swe:field/swe:Count[@definition='urn:ogc:def:property:CEOS:opt:NumberOfSamples']/swe:value 
					!= ''"> <property name="NumberOfSamples"> <xsl:value-of select="swe:DataRecord/swe:field/swe:Count[@definition='urn:ogc:def:property:CEOS:opt:NumberOfSamples']/swe:value"/> 
					</property> </xsl:if> </group> </xsl:for-each> -->
				<xsl:for-each
					select="sensorML:member/sensorML:Component/sensorML:characteristics/swe:DataRecord[gml:name='Geometric Characteristics']">
					<group name="DetectorGeoCharsGroup">
						<xsl:for-each select="swe:field">
							<xsl:choose>
								<xsl:when test="swe:Quantity">
									<property name="{@name}">
										<xsl:value-of select="swe:Quantity/swe:value" />
										<xsl:value-of select="' '" />
										<xsl:value-of select="swe:Quantity/swe:uom/@code" />
									</property>
								</xsl:when>
								<xsl:when test="swe:Count">
									<property name="{@name}">
										<xsl:value-of select="swe:Count/swe:value" />
									</property>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- END: Detector Measurement Characteristics -->
				<!-- ================================================= -->

				<!-- ================================================= -->
				<!-- START: Detector Measurement Characteristics -->
				<!-- ================================================= -->
				<!-- <xsl:for-each select="sensorML:member/sensorML:Component/sensorML:characteristics[@xlink:role 
					= 'urn:ogc:def:role:CEOS:eop:MeasurementCharacteristics']"> <group name="DetectorMeasCharsGroup"> 
					<xsl:if test="swe:DataRecord/swe:field/swe:Category[@definition='urn:ogc:def:property:CEOS:eop:BandType']/swe:value 
					!= ''"> <property name="BandType"> <xsl:value-of select="swe:DataRecord/swe:field/swe:Category[@definition='urn:ogc:def:property:CEOS:eop:BandType']/swe:value"/> 
					</property> </xsl:if> <xsl:if test="swe:DataRecord/swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:opt:SpectralRange']/swe:value 
					!= ''"> <property name="SpectralRange"> <xsl:value-of select="swe:DataRecord/swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:opt:SpectralRange']/swe:value"/> 
					<xsl:value-of select="' '"/> <xsl:value-of select="swe:DataRecord/swe:field/swe:QuantityRange[@definition='urn:ogc:def:property:CEOS:opt:SpectralRange']/swe:uom/@code"/> 
					</property> </xsl:if> <xsl:if test="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:SNR']/swe:value 
					!= ''"> <property name="SNR"> <xsl:value-of select="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:SNR']/swe:value"/> 
					<xsl:value-of select="' '"/> <xsl:value-of select="swe:DataRecord/swe:field/swe:Quantity[@definition='urn:ogc:def:property:CEOS:eop:SNR']/swe:uom/@code"/> 
					</property> </xsl:if> </group> </xsl:for-each> -->
				<xsl:for-each
					select="sensorML:member/sensorML:Component/sensorML:characteristics/swe:DataRecord[gml:name='Measurement Characteristics']">
					<group name="DetectorMeasCharsGroup">
						<xsl:for-each select="swe:field">
							<xsl:choose>
								<xsl:when test="swe:Quantity">
									<property name="{@name}">
										<xsl:value-of select="swe:Quantity/swe:value" />
										<xsl:value-of select="' '" />
										<xsl:value-of select="swe:Quantity/swe:uom/@code" />
									</property>
								</xsl:when>
								<xsl:when test="swe:Count">
									<property name="{@name}">
										<xsl:value-of select="swe:Count/swe:value" />
									</property>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</group>
				</xsl:for-each>
				<!-- ================================================= -->
				<!-- END: Detector Measurement Characteristics -->
				<!-- ================================================= -->
			</xsl:if>
			<xsl:for-each select="//rim:Association">
				<group name="InstrumentsGroup">
					<property name="Instrument">
						<xsl:value-of select="@targetObject" />
					</property>
					<property name="InstrumentLabel">
						<xsl:value-of select="substring-after(./@targetObject,':::::')" />
					</property>
				</group>
			</xsl:for-each>
		</element>
	</xsl:template>
</xsl:stylesheet>

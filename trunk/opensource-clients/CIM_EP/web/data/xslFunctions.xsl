<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:common="http://exslt.org/common"
	xmlns:math="http://exslt.org/math" xmlns:str="http://exslt.org/strings"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template name="joinString">
		<xsl:param name="stringList" />
		<xsl:param name="separator" />

		<xsl:for-each select="common:node-set($stringList)">
			<xsl:choose>
				<xsl:when
					test="$separator != '' and position() != last()">
					<xsl:value-of select="concat(normalize-space(.),$separator)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(.)" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:text />
		</xsl:for-each>

	</xsl:template>

	<xsl:template name="surroundString">
		<xsl:param name="string" />
		<xsl:param name="surroundChar" />
		<xsl:variable name="surroundedString">
			<xsl:value-of select="$surroundChar" />
			<xsl:value-of select="translate($string, ' ', '$')" />
			<xsl:value-of select="$surroundChar" />
		</xsl:variable>
		<xsl:value-of
			select="translate(translate(normalize-space($surroundedString), ' ', ''), '$', ' ') " />

	</xsl:template>

	<xsl:template name="generateIntegerList">
		<xsl:param name="from" />
		<xsl:param name="to" />
		<xsl:param name="step" />
		<value>
			<xsl:value-of select="$from" />
		</value>
		<xsl:if test="number($from) &lt; number($to - 1)">
			<xsl:call-template name="generateIntegerList">
				<xsl:with-param name="from">
					<xsl:value-of select="$from + $step" />
				</xsl:with-param>
				<xsl:with-param name="to" select="$to" />
				<xsl:with-param name="step" select="$step" />
			</xsl:call-template>
		</xsl:if>

	</xsl:template>

	<xsl:template name="generateNavigationBar">
		<xsl:param name="nextRecord" />
		<xsl:param name="numberCollection" />
		<xsl:param name="numberOfRecordsMatched" />
		<xsl:param name="numberOfRecordsReturned" />
		<xsl:param name="cursor" />
		<xsl:if
			test="number($numberOfRecordsReturned) &gt; 0 and number($cursor) &gt; 0 ">

			<p>
				<xsl:variable name="firstReturnedResult">
					<xsl:choose>
						<xsl:when test="$nextRecord = 0">
							<xsl:value-of
								select="$numberOfRecordsMatched - $numberOfRecordsReturned + 1" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="$nextRecord - $numberOfRecordsReturned - $numberCollection + 1" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="lastReturnedResult">
					<xsl:choose>
						<xsl:when test="$nextRecord = 0">
							<xsl:value-of
								select="$numberOfRecordsMatched" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="$nextRecord - $numberCollection" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<span id="resultNumber">
					Results :
					<b>
						<xsl:value-of select="$firstReturnedResult" />
					</b>
					-
					<b>
						<xsl:value-of select="$lastReturnedResult" />
					</b>
					of
					<b>
						<xsl:value-of select="$numberOfRecordsMatched" />
					</b>
				</span>

				Page :

				<xsl:variable name="numberOfReturnedPage"
					select="ceiling($numberOfRecordsMatched div ($cursor * $numberCollection))" />
				<xsl:variable name="currentPage">
					<xsl:choose>
						<xsl:when test="$nextRecord = 0">
							<xsl:value-of
								select="$numberOfReturnedPage" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="ceiling($nextRecord div ($cursor * $numberCollection)) - 1" />
						</xsl:otherwise>
					</xsl:choose>

				</xsl:variable>

				<span id="navigator">
					<xsl:variable name="beginNavigator">
						<xsl:choose>
							<xsl:when
								test="($currentPage &lt; 6) or (( $numberOfReturnedPage - 10) &lt; 1)">
								1
							</xsl:when>
							<xsl:when
								test="($numberOfReturnedPage - $currentPage) &lt; 10">
								<xsl:value-of
									select="$numberOfReturnedPage - 10" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$currentPage - 5" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="endNavigator">
						<xsl:choose>
							<xsl:when
								test="($currentPage + 5 &gt; $numberOfReturnedPage) or ($numberOfReturnedPage &lt; 10)">
								<xsl:value-of
									select="$numberOfReturnedPage" />
							</xsl:when>
							<xsl:when test="$currentPage &lt; 5">
								10
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$currentPage + 5" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="navigatorSource">
						<xsl:call-template name="generateIntegerList">
							<xsl:with-param name="from"
								select="$beginNavigator" />
							<xsl:with-param name="to"
								select="$endNavigator +1" />
							<xsl:with-param name="step">
								1
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:if test="$beginNavigator &gt; 1">
						<span>
							<a href="#" alt="Previous">
								<xsl:attribute name="onclick">
                                                    cursorValue =
                                                    ((<xsl:value-of
										select="$currentPage" /> -2 )
										* <xsl:value-of
										select="$cursor" />
										
										+ 1);
                                                    <![CDATA[

                                            var MASSform = portalScripts.getFromSSEDocument('MASS');
                                            if (MASSform != null) {
                                                MASSform.used_cursor.value = cursorValue;
                                                
                                                processSearch(portalScripts.getFromSSEWindow('frameViewer'),portalScripts.getFromSSEDocument('ViewerForm'),MASSform);
                                            }
                                            return false;
]]>
                                                </xsl:attribute>
								&lt;
							</a>
						</span>
					</xsl:if>


					<xsl:for-each
						select="common:node-set($navigatorSource)/value">
						<span>
							<xsl:variable name="currentValue"
								select="number(.)" />
							<xsl:choose>
								<xsl:when
									test="$currentValue = $currentPage">
									<xsl:value-of
										select="$currentValue" />

								</xsl:when>
								<xsl:otherwise>
									<a href="#">
										<xsl:attribute name="onclick">
                                                    cursorValue =
                                                    (<xsl:value-of
												select="$currentValue" /> - 1) * <xsl:value-of
												select="$cursor " /> + 1
                                                    ;
                                                    <![CDATA[



                                            var MASSform = portalScripts.getFromSSEDocument('MASS');
                                            if (MASSform != null) {
                                                MASSform.used_cursor.value = cursorValue;
                                                
                                                processSearch(portalScripts.getFromSSEWindow('frameViewer'),portalScripts.getFromSSEDocument('ViewerForm'),MASSform);
                                            }
                                            return false;
]]>
                                                </xsl:attribute>
										<xsl:value-of
											select="$currentValue" />
									</a>
								</xsl:otherwise>
							</xsl:choose>
						</span>
					</xsl:for-each>

					<xsl:if
						test="$endNavigator &lt; $numberOfReturnedPage">
						<span>
							<a href="#" alt="Next">
								<xsl:attribute name="onclick">
                                                    cursorValue =
                                                    (<xsl:value-of
										select="$currentPage" /> 
                                        * <xsl:value-of
										select="$cursor" /> + 1);
                                                    <![CDATA[

                                            var MASSform = portalScripts.getFromSSEDocument('MASS');
                                            if (MASSform != null) {
                                                MASSform.used_cursor.value = cursorValue;
                                                
                                                processSearch(portalScripts.getFromSSEWindow('frameViewer'),portalScripts.getFromSSEDocument('ViewerForm'),MASSform);
                                            }
                                            return false;
]]>
                                                </xsl:attribute>
								&gt;
							</a>
						</span>
					</xsl:if>
				</span>


				<b>
					<xsl:value-of select="$currentPage" />
				</b>
				/
				<b>
					<xsl:value-of select="$numberOfReturnedPage" />
				</b>
			</p>


		</xsl:if>
	</xsl:template>


	<!--  *********************************************************
		function use to split string to an array (http://aspn.activestate.com/ASPN/Cookbook/XSLT/Recipe/189861)
		ex:
		<xsl:variable name="coordoniatesSplitted">
		<xsl:call-template name="split-string">
		<xsl:with-param name="all">
		<text>
		<xsl:value-of select="$coordoniatesNormalized"/>
		</text>
		</xsl:with-param>
		<xsl:with-param name="seperator" select="','"/>
		</xsl:call-template>
		</xsl:variable>
		
		
		*********************************************************  -->

	<xsl:template name="split-string">
		<xsl:param name="all" />
		<xsl:param name="seperator" />
		<xsl:variable name="all_text"
			select="common:node-set($all)/text" />
		<xsl:variable name="all_index_star"
			select="common:node-set($all)/index/*" />

		<xsl:call-template name="split-string-impl">
			<xsl:with-param name="all" select="$all" />
			<xsl:with-param name="seperator" select="$seperator" />
			<xsl:with-param name="all_text" select="$all_text" />
			<xsl:with-param name="all_index_star"
				select="$all_index_star" />
		</xsl:call-template>
	</xsl:template>


	<xsl:template name="split-string-impl">
		<xsl:param name="all" />
		<xsl:param name="seperator" />
		<xsl:param name="all_text" />
		<xsl:param name="all_index_star" />
		<xsl:variable name="first"
			select="substring-before($all_text,$seperator)" />
		<xsl:choose>
			<xsl:when
				test="$first or substring-after($all_text,$seperator)">
				<xsl:call-template name="split-string">
					<xsl:with-param name="all">
						<text>
							<xsl:value-of
								select="substring-after($all_text,$seperator)" />
						</text>
						<index>
							<xsl:copy-of select="$all_index_star" />
							<xsl:text>
                            </xsl:text>
							<w>
								<xsl:value-of select="$first" />
							</w>
						</index>
					</xsl:with-param>
					<xsl:with-param name="seperator"
						select="$seperator" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<index>
					<xsl:copy-of select="$all_index_star" />
					<xsl:text>
                    </xsl:text>
					<w>
						<xsl:value-of select="$all_text" />
					</w>
				</index>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="troncateDouble">

		<xsl:param name="self" />
		<xsl:param name="precision" />

		<xsl:variable name="powerPrecision">
			<xsl:value-of select="math:power(10, $precision)" />
		</xsl:variable>

		<xsl:variable name="roundPart">
			<xsl:value-of select="floor($self)" />
		</xsl:variable>
		<xsl:variable name="floatPart">
			<xsl:value-of select="$self - $roundPart" />
		</xsl:variable>
		<xsl:variable name="floatPartRounded">
			<xsl:value-of select="round($floatPart*$powerPrecision)" />
		</xsl:variable>
		<xsl:variable name="floatPartTroncated">
			<xsl:value-of
				select="$floatPartRounded div $powerPrecision" />
		</xsl:variable>


		<xsl:value-of select="$roundPart + $floatPartTroncated" />


	</xsl:template>

	<xsl:template name="parseCoordonates">
		<xsl:param name="coordonates" />

		<xsl:variable name="coordonatesNormalized">
			<xsl:value-of
				select="translate(normalize-space($coordonates), ' ', ',')" />
		</xsl:variable>

		<xsl:for-each select="str:split($coordonatesNormalized, ',')">
			<coordonate>
				<xsl:call-template name="troncateDouble">
					<xsl:with-param name="self" select="." />
					<xsl:with-param name="precision" select="2" />
				</xsl:call-template>
			</coordonate>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="formatCoordonates">
		<xsl:param name="coordonates" />

		<xsl:variable name="parsedCoordonates">
			<xsl:call-template name="parseCoordonates">
				<xsl:with-param name="coordonates">
					<xsl:value-of select="$coordonates" />
				</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each
			select="common:node-set($parsedCoordonates)/coordonate">
			<xsl:value-of select="." /><!-- <xsl:if test="position() != last()">, </xsl:if> -->
			<xsl:text> </xsl:text>

		</xsl:for-each>
	</xsl:template>



</xsl:stylesheet>
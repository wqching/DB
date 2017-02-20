<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:date="http://exslt.org/dates-and-times">
  <xsl:output method="xml" indent="yes" encoding="iso-8859-1"/>
  <xsl:strip-space elements="test"/>
  <xsl:template match="/">
    <html>
      <xsl:apply-templates/>
    </html>
  </xsl:template>
  <xsl:template match="SquishReport">
    <body>
    <h1>Summary</h1>
    <table border="0" cellpadding="3">
    <tr>
    <td>Test cases</td><td><xsl:value-of select="count(//test)"/></td>
    </tr>
    <tr>
    <td>Tests</td><td><xsl:value-of select="count(//result)"/></td>
    </tr>
    <tr>
    <td>Passes</td><td><xsl:value-of select="count(//result[@type='PASS'])"/> (including <xsl:value-of select="count(//result[@type='EXPECTED_FAIL'])"/> expected failures)</td>
    </tr>
    <tr>
    <td>Fails</td><td><xsl:value-of select="count(//result[@type='FAIL'])"/> (including <xsl:value-of select="count(//result[@type='UNEXPECTED_PASS'])"/> unexpected passes)</td>
    </tr>
    <tr>
    <td>Errors</td><td><xsl:value-of select="count(//result[@type='ERROR'])"/></td>
    </tr>
    <tr>
    <td>Fatals</td><td><xsl:value-of select="count(//result[@type='FATAL'])"/></td>
    </tr>
    </table>
      <h1>Results</h1>
      <table border="0" cellpadding="3" width="100%">
      <xsl:apply-templates/>
      </table>
    </body>
  </xsl:template>
  <xsl:template match="test">
      <tr bgcolor="#EEEEEE">
          <td>START</td>
          <xsl:variable name="date" select="substring(prolog/@time, 1, 10)"/>
          <xsl:variable name="time" select="substring(prolog/@time, 12, 8)"/>
          <td><xsl:value-of
          select="concat(date:day-abbreviation($date), ', ',
          date:day-in-month($date), ' ',
          date:month-abbreviation($date), ' ', date:year($date), ' ',
          date:time($time))"/></td>
          <td></td>
          <td>Start '<xsl:value-of select="@name"/>'</td>
          <td>Test '<xsl:value-of select="@name"/>' started</td>
      </tr>
      <xsl:apply-templates/>
      <tr bgcolor="#EEEEEE">
          <td>END</td>
          <td><xsl:value-of select="epilog/@time"/></td>
          <td></td>
          <td>End '<xsl:value-of select="@name"/>'</td>
          <td>Test '<xsl:value-of select="@name"/>' ended</td>
      </tr>
  </xsl:template>
  <xsl:template match="result">
       <tr bgcolor="#80FF80">
       <td><xsl:value-of select="@type"/></td>
       <td><xsl:value-of select="@time"/></td>
       <td><xsl:value-of select="../@file"/>:<xsl:value-of select="../@line"/></td>
       <td><xsl:value-of select="description"/></td>
       <td><xsl:value-of select="description[@type='DETAILED']"/></td>
       </tr>
  </xsl:template>
  <xsl:template match="message">
     <tr bgcolor="#80FF80">
     <td><xsl:value-of select="@type"/></td>
     <td><xsl:value-of select="@time"/></td>
     <td></td>
     <td></td>
     <td><xsl:value-of select="."/></td>
     </tr>
  </xsl:template>
</xsl:stylesheet>

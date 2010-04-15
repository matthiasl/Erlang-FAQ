<?xml version="1.0" encoding="utf-8"?>
<!--      
     #
     # %CopyrightBegin%
     #
     # Copyright Ericsson AB 2009-2010. All Rights Reserved.
     #
     # The contents of this file are subject to the Erlang Public License,
     # Version 1.1, (the "License"); you may not use this file except in
     # compliance with the License. You should have received a copy of the
     # Erlang Public License along with this software. If not, it can be
     # retrieved online at http://www.erlang.org/.
     #
     # Software distributed under the License is distributed on an "AS IS"
     # basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
     # the License for the specific language governing rights and limitations
     # under the License.
     #
     # %CopyrightEnd%
     
     -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/02/xpath-functions"> 

  <xsl:include href="faq_html_params.xsl"/>

  <!-- Page layout -->
  <xsl:template name="pagelayout">
    <xsl:param name="chapnum"/>
    <xsl:param name="curModule"/>
    <html>
      <head>
        <link rel="stylesheet" href="{$topdocdir}/otp_doc.css" type="text/css"/>
        <title>Erlang -- <xsl:value-of select="header/title"/></title>
      </head>
      <body bgcolor="white" text="#000000" link="#0000ff" vlink="#ff00ff" alink="#ff0000">

        <div id="container">
          <script id="js" type="text/javascript" language="JavaScript" src="{$topdocdir}/js/flipmenu/flipmenu.js"/>
          <script id="js2" type="text/javascript" src="{$topdocdir}/js/erlresolvelinks.js"></script>
          <script language="JavaScript" type="text/javascript">
            <xsl:text disable-output-escaping="yes"><![CDATA[
            <!--            
              function getWinHeight() {
                var myHeight = 0;
                if( typeof( window.innerHeight ) == 'number' ) {
                  //Non-IE
                  myHeight = window.innerHeight;
                } else if( document.documentElement && ( document.documentElement.clientWidth || 
                                                         document.documentElement.clientHeight ) ) {
                  //IE 6+ in 'standards compliant mode'
                  myHeight = document.documentElement.clientHeight;
                } else if( document.body && ( document.body.clientWidth || document.body.clientHeight ) ) {
                  //IE 4 compatible
                  myHeight = document.body.clientHeight;
                }
                return myHeight;            
              }

              function setscrollpos() {
                var objf=document.getElementById('loadscrollpos');
                 document.getElementById("leftnav").scrollTop = objf.offsetTop - getWinHeight()/2;
              }

              function addEvent(obj, evType, fn){ 
                if (obj.addEventListener){ 
                obj.addEventListener(evType, fn, true); 
                return true; 
              } else if (obj.attachEvent){ 
                var r = obj.attachEvent("on"+evType, fn); 
                return r; 
              } else { 
                return false; 
              } 
             }

             addEvent(window, 'load', setscrollpos);

             //-->]]></xsl:text>
          </script>
          <!-- Generate menu -->
          <xsl:call-template name="menu">
            <xsl:with-param name="chapnum" select="$chapnum"/>
            <xsl:with-param name="curModule" select="$curModule"/>
          </xsl:call-template>
   
          <div id="content">
            <div class="innertube">

              <!-- Insert the node-specific content -->
              <xsl:call-template name="content">
                <xsl:with-param name="chapnum" select="$chapnum"/>
              </xsl:call-template>
            </div>

            <div class="footer">
              <hr/>
              <p>
                <br/>
              </p>
            </div>

          </div>
        </div>
      </body>
    </html>
  </xsl:template>


  <!-- Content -->
  <xsl:template name="content">
    <xsl:param name="chapnum"/>

    <xsl:variable name="lname"><xsl:value-of select="local-name()"/></xsl:variable>

    <xsl:if test="$lname = 'part'">
      <!-- .../part -->
      <xsl:call-template name="part.content" />
    </xsl:if>    
    <xsl:if test="$lname = 'chapter'">
      <!-- .../part/chapter -->
      <xsl:call-template name="chapter.content">
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:call-template>
    </xsl:if>  
 </xsl:template>


  <!-- Menu -->
  <xsl:template name="menu">
    <xsl:param name="chapnum"/>
    <xsl:param name="curModule"/>
    <xsl:if test="(local-name() = 'part') or ((local-name() = 'chapter') and ancestor::part)">
      <!-- .../part or.../part/chapter  -->
      <xsl:call-template name="menu.ug">
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>       

  <!-- Menu.ug -->
  <xsl:template name="menu.ug">
    <xsl:param name="chapnum"/>

    <div id="leftnav">
      <div class="innertube">
        <img alt="Erlang logo" src="{$topdocdir}/erlang-logo.png"/>
        <br/>
        <p>
          <strong><xsl:value-of select="header/title"/></strong><br/>
          <strong></strong><br/>
        </p>
        <a href="faq.html">Cover</a>
        <br/>
        <br/>
        <a href="javascript:openAllFlips()">Expand All</a><br/>
        <a href="javascript:closeAllFlips()">Contract All</a>
        <p>
          <small>
            <strong>Table of Contents</strong>
          </small>
        </p>
        <ul class="flipMenu" imagepath="{$topdocdir}/js/flipmenu">
          <xsl:call-template name="menu.chapter">
            <xsl:with-param name="entries" select="/part/chapter[header/title]"/>
            <xsl:with-param name="chapnum" select="$chapnum"/>
          </xsl:call-template>
        </ul>
      </div>
    </div>            
  </xsl:template>
  
  <xsl:template name="menu.chapter">
    <xsl:param name="entries"/>
    <xsl:param name="chapnum"/>
    <xsl:for-each select="$entries">
      <xsl:variable name="chapter_file">
        <xsl:value-of select='substring-before(header/file, ".xml")'/>
      </xsl:variable>
      <xsl:variable name="curchapnum"><xsl:number/></xsl:variable>
      <xsl:variable name="expanded">
        <xsl:choose>
          <xsl:when test="$chapnum = $curchapnum">true</xsl:when>
          <xsl:otherwise>false</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="loadscrollpos">
        <xsl:choose>
          <xsl:when test="$chapnum = $curchapnum">loadscrollpos</xsl:when>
          <xsl:otherwise>no</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <li id="{$loadscrollpos}" title="{header/title}" expanded="{$expanded}">
        <xsl:value-of select="header/title"/>
        <ul>
          <li>
            <a href="{$chapter_file}.html">
              Top of chapter
            </a>
          </li>         
          <xsl:call-template name="menu.section">
            <xsl:with-param name="entries"
              select="section[title]"/>
            <xsl:with-param name="chapter_file"><xsl:value-of select="$chapter_file"/></xsl:with-param>
          </xsl:call-template>
        </ul>
      </li>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="menu.section">
    <xsl:param name="entries"/>
    <xsl:param name="chapter_file"/>
    <xsl:for-each select="$entries">
      <li title="{title}">
        <a href="{$chapter_file}.html#{generate-id(title)}">
          <xsl:value-of select="title"/>
        </a>
      </li>
    </xsl:for-each>
  </xsl:template>


  <!-- Book -->
  <xsl:template match="/book">

    <xsl:apply-templates name="parts"/>
    <xsl:apply-templates name="applications"/>

  </xsl:template>

  <!-- Parts -->
  <xsl:template match="parts">
    <xsl:apply-templates name="part"/>
  </xsl:template>

  <!-- Applications -->
  <xsl:template match="applications">
    <xsl:apply-templates name="application"/>
  </xsl:template>


 <!-- Header -->
  <xsl:template match="header">
  </xsl:template>

  <!-- Section/Title -->
  <xsl:template match="section/title">
 </xsl:template>

 <xsl:template match="pagetext">
 </xsl:template>


  <!-- Chapter/Section -->
  <xsl:template match="chapter/section">
    <xsl:param name="chapnum"/>  
    <h3>
      <a name="{generate-id(title)}">
        <xsl:value-of select="$chapnum"/>.<xsl:number/>&#160;
        <xsl:value-of select="title"/>
      </a>
    </h3>
    <xsl:apply-templates>
      <xsl:with-param name="chapnum" select="$chapnum"/>
      <xsl:with-param name="sectnum"><xsl:number/></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Chapter/Subsection -->
  <xsl:template match="chapter/section/section">
    <xsl:param name="chapnum"/>
    <xsl:param name="sectnum"/>
    <h4>
      <!-- xsl:value-of select="$partnum"/>.<xsl:value-of select="$chapnum"/>.<xsl:value-of select="$sectnum"/>.<xsl:number/ -->
      <xsl:value-of select="title"/>
    </h4>
    <xsl:apply-templates>
      <xsl:with-param name="chapnum" select="$chapnum"/>
    </xsl:apply-templates>
  </xsl:template>



  <!-- *ref/Section -->
  <xsl:template match="erlref/section|cref/section|comref/section|fileref/section|appref/section">
    <xsl:param name="chapnum"/>
    <h3>
      <a name="{generate-id(title)}">
        <xsl:value-of select="title"/>
      </a>
    </h3>
    <div class="REFBODY">
    <xsl:apply-templates>
      <xsl:with-param name="chapnum" select="$chapnum"/>
    </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- *ref/Subsection -->
  <xsl:template match="erlref/section/section|cref/section/section|comref/section/section|fileref/section/section|appref/section/section">
    <xsl:param name="chapnum"/>
    <xsl:param name="sectnum"/>
    <h4>
      <xsl:value-of select="title"/>
    </h4>
    <div class="REFBODY">
    <xsl:apply-templates>
      <xsl:with-param name="chapnum" select="$chapnum"/>
    </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- Lists -->
  
  <xsl:template match="list">
    <xsl:param name="chapnum"/>
    <ul>
      <xsl:apply-templates>
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:apply-templates>
    </ul>
  </xsl:template>

  <xsl:template match="list/item">
    <xsl:param name="chapnum"/>
    <li>
      <xsl:apply-templates>
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:apply-templates>
    </li>
  </xsl:template>


  <xsl:template match="taglist">
    <xsl:param name="chapnum"/>
    <dl>
      <xsl:apply-templates>
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:apply-templates>
    </dl>
  </xsl:template>
  
  <xsl:template match="taglist/tag">
    <xsl:param name="chapnum"/>
    <dt>
      <strong>
        <xsl:apply-templates/>
      </strong>
    </dt>
  </xsl:template>


  <xsl:template match="taglist/item">
    <xsl:param name="chapnum"/>
    <dd>
      <xsl:apply-templates>
        <xsl:with-param name="chapnum" select="$chapnum"/>
      </xsl:apply-templates>
    </dd>
  </xsl:template>

  <!-- Note -->
  <xsl:template match="note">
    <xsl:param name="chapnum"/>
    <div class="note">
      <div class="label">Note</div>
      <div class="content">
        <p>
          <xsl:apply-templates>
            <xsl:with-param name="chapnum" select="$chapnum"/>
          </xsl:apply-templates>
        </p>
      </div>
    </div>
  </xsl:template>

  <!-- Warning -->
  <xsl:template match="warning">
    <xsl:param name="chapnum"/>
    <div class="warning">
      <div class="label">Warning</div>
      <div class="content">
        <p>
          <xsl:apply-templates>
            <xsl:with-param name="chapnum" select="$chapnum"/>
          </xsl:apply-templates>
        </p>
      </div>
    </div>          
  </xsl:template>

 <!-- Paragraph -->
  <xsl:template match="p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>


  <!-- Inline elements -->
  <xsl:template match="b">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>

  <xsl:template match="br">
    <br/>
  </xsl:template>

  <xsl:template match="c">
    <span class="code"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="em">
    <strong><xsl:apply-templates/></strong> 
  </xsl:template>

  <!-- Code -->
  <xsl:template match="code">
    <xsl:param name="chapnum"/>
    <xsl:variable name="codenum">
      <xsl:number level="any" from="chapter" count="code"/>
    </xsl:variable>
    <div class="example"><pre><xsl:apply-templates/></pre></div>
  </xsl:template>

  <!-- Pre -->
  <xsl:template match="pre">
    <xsl:param name="chapnum"/>
    <xsl:variable name="codenum">
      <xsl:number level="any" from="chapter" count="code"/>
    </xsl:variable>
    <div class="example"><pre><xsl:apply-templates/></pre></div>
  </xsl:template>


  <!-- Table -->
  <xsl:template match="table">
    <xsl:param name="chapnum"/>
    <xsl:variable name="tabnum">
      <xsl:number level="any" from="chapter" count="table"/>
    </xsl:variable>
    <table border="1" cellpadding="2" cellspacing="0">
      <!-- tbody-->
      <xsl:apply-templates select="row">
        <xsl:with-param name="chapnum" select="$chapnum"/>
        <xsl:with-param name="tabnum" select="$tabnum"/>
      </xsl:apply-templates>
      <!-- /tbody-->
    </table>
    <xsl:apply-templates select="tcaption">
      <xsl:with-param name="chapnum" select="$chapnum"/>
      <xsl:with-param name="tabnum" select="$tabnum"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="row">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>

  <xsl:template match="cell">
    <td align="left" valign="middle">
      <xsl:apply-templates/>
    </td>
  </xsl:template>


  <xsl:template match="tcaption">
    <xsl:param name="chapnum"/>
    <xsl:param name="tabnum"/>

      <em>Table
        <xsl:value-of select="$chapnum"/>.<xsl:value-of select="$tabnum"/>:
        &#160;
        <xsl:apply-templates/>
      </em>

  </xsl:template>

  <!-- Image -->
  <xsl:template match="image">
    <xsl:param name="chapnum"/>
    <xsl:variable name="fignum">
      <xsl:number level="any" from="chapter" count="image"/>
    </xsl:variable>

      <img alt="IMAGE MISSING" src="{@file}"/><br/>

      <xsl:apply-templates>
        <xsl:with-param name="chapnum" select="$chapnum"/>
        <xsl:with-param name="fignum" select="$fignum"/>
      </xsl:apply-templates>


  </xsl:template>


  <xsl:template match="icaption">
    <xsl:param name="chapnum"/>
    <xsl:param name="fignum"/>

      <em>Figure
        <xsl:value-of select="$chapnum"/>.<xsl:value-of select="$fignum"/>:
        &#160;
        <xsl:apply-templates/>
      </em>

  </xsl:template>




  <!--Users Guide -->
  <!-- Part -->
  <xsl:template match="/part">
    <xsl:document href="{$outdir}/faq.html" method="html"  encoding="UTF-8" indent="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN">
      <xsl:call-template name="pagelayout"/>
    </xsl:document>
  </xsl:template>


  <!-- Part content-->
  <xsl:template name="part.content">
    <div class="frontpage"/>

    <center><h1><xsl:value-of select="header/title"/></h1></center>
    <center><h4><xsl:value-of select="$gendate"/></h4></center>

    <xsl:apply-templates select="chapter"/>
          
  </xsl:template>


  <!-- Chapter (if top tag)-->
  <xsl:template match="/chapter">

    <xsl:document href="{substring-before(header/file, '.xml')}.html" method="html" encoding="UTF-8" indent="yes" 
      doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN">

      <xsl:call-template name="pagelayout">
        <xsl:with-param name="chapnum"><xsl:number/></xsl:with-param>
      </xsl:call-template>
    </xsl:document>
  </xsl:template>

  <!-- Chapter -->
  <xsl:template match="chapter">

    <xsl:document href="{substring-before(header/file, '.xml')}.html" method="html" encoding="UTF-8" indent="yes" 
      doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN">

      <xsl:call-template name="pagelayout">
        <xsl:with-param name="chapnum"><xsl:number/></xsl:with-param>
      </xsl:call-template>
    </xsl:document>
  </xsl:template>


  <!-- Chapter content-->
  <xsl:template name="chapter.content">
    <xsl:param name="chapnum"/>

    <!-- center-->
      <h1>
        <xsl:value-of select="$chapnum"/>&#160;<xsl:value-of select="header/title"/>
      </h1>
    <!-- /center-->

    <xsl:apply-templates>
      <xsl:with-param name="chapnum" select="$chapnum"/>
    </xsl:apply-templates>

  </xsl:template>




  <!-- Reference Manual -->

  <!-- Module -->
  <xsl:template match="module">
    <xsl:param name="partnum"/>
    <h3>MODULE</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- Modulesummary -->
  <xsl:template match="modulesummary">
    <xsl:param name="partnum"/>
    <h3>MODULE SUMMARY</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- Lib -->
  <xsl:template match="lib">
    <xsl:param name="partnum"/>
    <h3>C LIBRARY</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- Libsummary -->
  <xsl:template match="libsummary">
    <xsl:param name="partnum"/>
    <h3>LIBRARY SUMMARY</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- Com -->
  <xsl:template match="com">
    <xsl:param name="partnum"/>
    <h3>COMMAND</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- Comsummary -->
  <xsl:template match="comsummary">
    <xsl:param name="partnum"/>
    <h3>COMMAND SUMMARY</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- File -->
  <xsl:template match="file">
    <xsl:param name="partnum"/>
    <h3>FILE</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- Filesummary -->
  <xsl:template match="filesummary">
    <xsl:param name="partnum"/>
    <h3>FILE SUMMARY</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- App -->
  <xsl:template match="app">
    <xsl:param name="partnum"/>
    <h3>APPLICATION</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>


  <!-- Appsummary -->
  <xsl:template match="appsummary">
    <xsl:param name="partnum"/>
    <h3>APPLICATION SUMMARY</h3>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- Description -->
  <xsl:template match="description">
    <xsl:param name="partnum"/>
    <h3>DESCRIPTION</h3>
    <div class="REFBODY">
      <p>
        <xsl:apply-templates>
          <xsl:with-param name="partnum" select="$partnum"/>
        </xsl:apply-templates>
      </p>
    </div>
  </xsl:template>

  <!-- Funcs -->
  <xsl:template match="funcs">
    <xsl:param name="partnum"/>

    <h3>
      <xsl:text>EXPORTS</xsl:text>
    </h3>

    <xsl:apply-templates>
      <xsl:with-param name="partnum" select="$partnum"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- Func -->
  <xsl:template match="func">
    <xsl:param name="partnum"/>
   
    <p><xsl:apply-templates select="name"/></p>

    <xsl:apply-templates select="fsummary|type|desc">
      <xsl:with-param name="partnum" select="$partnum"/>
    </xsl:apply-templates>

  </xsl:template>

  <xsl:template match="name">

    <xsl:variable name="tmpstring">
      <xsl:value-of select="substring-before(substring-after(., '('), '->')"/>
    </xsl:variable>     

    <xsl:variable name="ustring">
      <xsl:choose>
        <xsl:when test="string-length($tmpstring) > 0">
          <xsl:call-template name="remove-paren">
            <xsl:with-param name="string" select="$tmpstring"/>
          </xsl:call-template>            
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="remove-paren">
            <xsl:with-param name="string" select="substring-after(., '(')"/>
          </xsl:call-template>                      
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>      
        
    <xsl:variable name="arity">
      <xsl:call-template name="calc-arity">
        <xsl:with-param name="string" select="substring-before($ustring, ')')"/>
        <xsl:with-param name="no-of-pars" select="0"/> 
      </xsl:call-template>
    </xsl:variable> 
    
    <xsl:choose>
      <xsl:when test="ancestor::cref">
        <a name="{substring-before(nametext, '(')}"><span class="bold_code"><xsl:value-of select="ret"/><xsl:text> </xsl:text><xsl:value-of select="nametext"/></span></a><br/>
      </xsl:when>
      <xsl:when test="ancestor::erlref">
        <xsl:variable name="fname">
          <xsl:variable name="fname1">
            <xsl:value-of select="substring-before(., '(')"/>
          </xsl:variable>
          <xsl:variable name="fname2">
            <xsl:value-of select="substring-after($fname1, 'erlang:')"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="string-length($fname2) > 0">   
              <xsl:value-of select="$fname2"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$fname1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a name="{$fname}-{$arity}"><span class="bold_code"><xsl:value-of select="."/></span></a><br/>
      </xsl:when>
    </xsl:choose>
      
  </xsl:template>


  <!-- Type -->
  <xsl:template match="type">
    <xsl:param name="partnum"/>

    <div class="REFBODY"><p>Types:</p>  

      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
    
  </xsl:template>


  <!-- V -->
  <xsl:template match="v">
    <xsl:param name="partnum"/>
    <div class="REFTYPES">
      <span class="bold_code">
        <xsl:apply-templates>
          <xsl:with-param name="partnum" select="$partnum"/>
        </xsl:apply-templates>
      </span><br/>
    </div>
  </xsl:template>

  <!-- D -->
  <xsl:template match="d">
    <xsl:param name="partnum"/>
    <div class="REFBODY">
      <xsl:apply-templates>
        <xsl:with-param name="partnum" select="$partnum"/>
      </xsl:apply-templates>
    </div>
  </xsl:template>

  <!-- Desc -->
  <xsl:template match="desc">
    <xsl:param name="partnum"/>
    <div class="REFBODY">
      <p>
        <xsl:apply-templates>
          <xsl:with-param name="partnum" select="$partnum"/>
        </xsl:apply-templates>
      </p>
    </div>
  </xsl:template>


  <!-- Fsummary -->
  <xsl:template match="fsummary">
    <!-- This tag is skipped for now. -->
  </xsl:template>


  <xsl:template match="input">
    <span class="bold_code"><xsl:apply-templates/></span>
  </xsl:template>

  <xsl:template match="seealso">

    <xsl:variable name="filepart"><xsl:value-of select="substring-before(@marker, '#')"/></xsl:variable>
    <xsl:variable name="linkpart"><xsl:value-of select="translate(substring-after(@marker, '#'), '/', '-')"/></xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($filepart) > 0">
        <xsl:variable name="modulepart"><xsl:value-of select="substring-before($filepart, ':')"/></xsl:variable>
        <xsl:choose>
          <xsl:when test="string-length($modulepart) > 0">
            <xsl:variable name="filepart1"><xsl:value-of select="substring-after($filepart, ':')"/></xsl:variable>     
            <span class="bold_code"><a href="javascript:erlhref('{$topdocdir}/../','{$modulepart}','{$filepart1}.html#{$linkpart}');"><xsl:apply-templates/></a></span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="string-length($linkpart) > 0">
                <span class="bold_code"><a href="{$filepart}.html#{$linkpart}"><xsl:apply-templates/></a></span>
              </xsl:when>
              <xsl:otherwise>        
                <span class="bold_code"><a href="{$filepart}.html"><xsl:apply-templates/></a></span>        
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="string-length($linkpart) > 0">
            <span class="bold_code"><a href="#{$linkpart}"><xsl:apply-templates/></a></span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="modulepart"><xsl:value-of select="substring-before(@marker, ':')"/></xsl:variable>
            
            <xsl:choose>
              <xsl:when test="string-length($modulepart) > 0">
                <xsl:variable name="filepart1"><xsl:value-of select="substring-after(@marker, ':')"/></xsl:variable>     
                <span class="bold_code"><a href="javascript:erlhref('{$topdocdir}/../','{$modulepart}','{$filepart1}.html');"><xsl:apply-templates/></a></span>
              </xsl:when>
              <xsl:otherwise>
                <span class="bold_code"><a href="{@marker}.html"><xsl:apply-templates/></a></span>        
              </xsl:otherwise>
            </xsl:choose>            
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


  <xsl:template match="url">
    <span class="bold_code"><a href="{@href}"><xsl:apply-templates/></a></span>
  </xsl:template>


  <xsl:template match="marker">
    <a name="{@id}"><xsl:apply-templates/></a>
  </xsl:template>

  <xsl:template match="term">
    <xsl:value-of select="@id"/>
  </xsl:template>

  <xsl:template match="cite">
    <xsl:value-of select="@id"/>
  </xsl:template>



 <!-- Special templates to calculate the arity of functions -->
  <xsl:template name="calc-arity">
    <xsl:param name="string"/>
    <xsl:param name="no-of-pars"/>
   
    <xsl:variable name="length">
      <xsl:value-of select="string-length($string)"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$length > 0">
        <xsl:call-template name="calc-arity">
          <xsl:with-param name="string" select="substring-after($string, ',')"/>
          <xsl:with-param name="no-of-pars" select="$no-of-pars+1"/> 
        </xsl:call-template>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$no-of-pars"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="remove-paren">
    <xsl:param name="string"/>

    <xsl:variable name="str1">
      <xsl:call-template name="remove-paren-1">
        <xsl:with-param name="string" select="$string"/>
        <xsl:with-param name="start">(</xsl:with-param> 
        <xsl:with-param name="end">)</xsl:with-param> 
      </xsl:call-template>    
    </xsl:variable>

    <xsl:variable name="str2">
      <xsl:call-template name="remove-paren-1">
        <xsl:with-param name="string" select="$str1"/>
        <xsl:with-param name="start">{</xsl:with-param>
        <xsl:with-param name="end">}</xsl:with-param>
      </xsl:call-template>    
    </xsl:variable>

    <xsl:variable name="str3">
      <xsl:call-template name="remove-paren-1">
        <xsl:with-param name="string" select="$str2"/>
        <xsl:with-param name="start">[</xsl:with-param>
        <xsl:with-param name="end">]</xsl:with-param>
      </xsl:call-template>    
    </xsl:variable>

    <xsl:value-of select="$str3"/>

  </xsl:template>


  <xsl:template name="remove-paren-1">
    <xsl:param name="string"/>
    <xsl:param name="start"/>
    <xsl:param name="end"/>
   
    <xsl:variable name="tmp1">
      <xsl:value-of select="substring-before($string, $start)"/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="string-length($tmp1) > 0 or starts-with($string, $start)">
        <xsl:variable name="tmp2">
          <xsl:value-of select="substring-after($string, $end)"/>
        </xsl:variable>
        <xsl:variable name="retstring">
          <xsl:call-template name="remove-paren">
            <xsl:with-param name="string" select="$tmp2"/>
          </xsl:call-template>        
        </xsl:variable>
        <xsl:value-of select="concat(concat($tmp1, 'x'), $retstring)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$string"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

</xsl:stylesheet>

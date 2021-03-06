<%@tag description="required /assets" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@taglib prefix="fn" 
          uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="baseURL" 
       value="${fn:replace(pageContext.request.requestURL,
                pageContext.request.requestURI, pageContext.request.contextPath)}" />


<!-- javascripts globals -->
<script type="text/javascript">
    Globals = {};
    Globals.baseURL = "${baseURL}";
</script>

<!--  base css  -->
<link rel="stylesheet" href="${baseURL}/assets/css/grid.css" />
<link rel="stylesheet" href="${baseURL}/assets/css/fonts.css" />
<link rel="stylesheet" href="${baseURL}/assets/css/entypo.css" />
<link rel="stylesheet" href="${baseURL}/assets/css/base.css" />
<!--  /base css  -->

<!--  kendoUI -->
<link rel="stylesheet" href="${baseURL}/assets/js/kendo/styles/kendo.common.min.css" />
<link rel="stylesheet" href="${baseURL}/assets/js/kendo/styles/kendo.silver.min.css" />
<script type="text/javascript" src="${baseURL}/assets/js/kendo/js/jquery.min.js"></script>
<script type="text/javascript" src="${baseURL}/assets/js/kendo/js/kendo.all.min.js"></script>
<script type="text/javascript" src="${baseURL}/assets/js/kendo/lang/kendo.es-MX.js"></script>
<script type="text/javascript" src="${baseURL}/assets/js/kendo/js/cultures/kendo.culture.es-SV.min.js"></script>
<!--  /kendoUI -->

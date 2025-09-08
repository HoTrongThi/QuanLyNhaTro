<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:choose>
  <c:when test="${not empty error}">
{
  "error": "${error}",
  "previousReading": 0
}
  </c:when>
  <c:when test="${not empty previousReading}">
{
  "previousReading": ${previousReading.reading},
  "period": "${previousReading.month}/${previousReading.year}",
  "message": "Found previous reading from tenant ${previousReading.tenantId}"
}
  </c:when>
  <c:otherwise>
{
  "previousReading": 0,
  "message": "No previous reading found - this might be the first reading"
}
  </c:otherwise>
</c:choose>
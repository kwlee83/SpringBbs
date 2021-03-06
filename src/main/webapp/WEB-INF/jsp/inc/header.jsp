<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<h1 style="float: left;width: 150px;"><a href="../"><img src="../images/ci.gif" alt="java-school logo" /></a></h1>
<div id="memberMenu" style="float: right;position: relative;top: 7px;">
<security:authorize access="hasAnyRole('ROLE_USER','ROLE_ADMIN')">
	<security:authentication property="principal.username" var="check" />
</security:authorize>
<c:choose>
	<c:when test="${empty check}">
		<input type="button" value="로그인" onclick="location.href='../users/login'" />
		<input type="button" value="회원가입" onclick="location.href='../users/signUp'" />
	</c:when>
	<c:otherwise>
		<input type="button" value="로그아웃" onclick="location.href='../j_spring_security_logout'" />
		<input type="button" value="내정보수정" onclick="location.href='../users/editAccount'" />
	</c:otherwise>
</c:choose>
</div>
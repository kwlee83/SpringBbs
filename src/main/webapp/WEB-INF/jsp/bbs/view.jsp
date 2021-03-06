<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="security" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="Keywords" content="게시판 상세보기" />
<meta name="Description" content="게시판 상세보기" />
<title>BBS</title>
<link rel="stylesheet" href="../css/screen.css" type="text/css" />
<script type="text/javascript" src="../js/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="../js/bbs-view.js"></script>
</head>
<body>

<div id="wrap">

    <div id="header">
		<%@ include file="../inc/header.jsp" %>
    </div>
    
    <div id="main-menu">
		<%@ include file="../inc/main-menu.jsp" %>
    </div>
    
    <div id="container">
            <div id="content" style="min-height: 800px;">

<!-- 본문 시작 -->
<div id="url-navi">BBS</div>
<h1>${boardNm }</h1>
<div id="bbs">
<table>
<tr>
    <th style="width: 37px;text-align: left;vertical-align: top;">TITLE</th>
    <th style="text-align: left;color: #555;">${title }</th>
</tr>
</table>
<div id="gul-content">
    <span id="date-writer-hit">edited ${regdate } by ${name } hit ${hit }</span>
    <p>${content }</p>
    <p id="file-list" style="text-align: right">
    	<c:forEach var="file" items="${attachFileList }" varStatus="status">
    	   <a href="#" title="${file.filename }" class="download">${file.filename }</a>
			<security:authorize access="#email == principal.username or hasRole('ROLE_ADMIN')">
	    	<a href="#" title="${file.attachFileNo }">x</a>
			</security:authorize>
			<br />    	
		</c:forEach>
    </p>
</div>

<!--  덧글 반복 시작 -->
<c:forEach var="comment" items="${commentList }" varStatus="status">
<div class="comments">
    <span class="writer">${comment.name }</span>
    <span class="date">${comment.regdate }</span>
	<security:authorize access="#comment.email == principal.username or hasRole('ROLE_ADMIN')">
    <span class="modify-del">
        <a href="#" class="comment-toggle">수정</a> | <a href="#" class="comment-delete" title="${comment.commentNo }">삭제</a>
    </span>
	</security:authorize>
    <p class="view-comment">${comment.memo }</p>
    <form class="modify-comment" action="updateComment" method="post" style="display: none;">
    <p>
        <input type="hidden" name="commentNo" value="${comment.commentNo }" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="articleNo" value="${param.articleNo }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    <div style="text-align: right;">
            <a href="#">수정하기</a> | <a href="#">취소</a>
    </div>
    <div>
        <textarea class="modify-comment-ta" name="memo" rows="7" cols="50">${comment.memo }</textarea>
    </div>
    </form>
</div>
</c:forEach>
<!--  덧글 반복 끝 -->

<form id="addCommentForm" action="addComment" method="post">
	<p style="margin: 0;padding: 0">
		<input type="hidden" name="articleNo" value="${param.articleNo }" />
		<input type="hidden" name="boardCd" value="${param.boardCd }" />
		<input type="hidden" name="curPage" value="${param.curPage }" />
		<input type="hidden" name="searchWord" value="${param.searchWord }" />
	</p>
    <div id="addComment">
        <textarea name="memo" rows="7" cols="50"></textarea>
    </div>
    <div style="text-align: right;">
        <input type="submit" value="덧글남기기" />
    </div>
</form>

<div id="next-prev">
    <c:if test="${nextArticle != null }">
    <p>다음글 : <a href="#" title="${nextArticle.articleNo }">${nextArticle.title }</a></p>
    </c:if>
    <c:if test="${prevArticle != null }">
    <p>이전글 : <a href="#" title="${prevArticle.articleNo }">${prevArticle.title }</a></p>
    </c:if>
</div>

<div id="view-menu">
    <security:authorize access="#email == principal.username or hasRole('ROLE_ADMIN')">
    <div class="fl">
        <input type="button" value="수정" id="goModify" />
        <input type="button" value="삭제" id="goDelete" />
    </div>
    </security:authorize>        
    <div class="fr">
		<c:if test="${nextArticle != null }">    
        <input type="button" value="다음글" title="${nextArticle.articleNo }" id="next-article" />
		</c:if>
		<c:if test="${prevArticle != null }">        
        <input type="button" value="이전글" title="${prevArticle.articleNo}" id="prev-article" />
		</c:if>        
        <input type="button" value="목록" id="goList" />
        <input type="button" value="새글쓰기" id="goWrite" />
    </div>
</div>

<!-- 목록 -->
<table id="list-table">
<tr>
	<th style="width: 60px;">NO</th>
	<th>TITLE</th>
	<th style="width: 84px;">DATE</th>
	<th style="width: 60px;">HIT</th>
</tr>

<c:forEach var="article" items="${list }" varStatus="status">        
<tr>
	<td style="text-align: center;">
	<c:choose>
		<c:when test="${param.articleNo == article.articleNo }">	
		<img src="../images/arrow.gif" alt="현재글" />
		</c:when>
		<c:otherwise>
		${listItemNo - status.index }
		</c:otherwise>
	</c:choose>	
	</td>
	<td>
		<a href="#" title="${article.articleNo }">${article.title }</a>
		<c:if test="${article.attachFileNum > 0 }">		
		<img src="../images/attach.png" alt="첨부파일" />
		</c:if>
		<c:if test="${article.commentNum > 0 }">		
		<span class="bbs-strong">[${article.commentNum }]</span>
		</c:if>		
	</td>
	<td style="text-align: center;">${article.regdateForList }</td>
	<td style="text-align: center;">${article.hit }</td>
</tr>
</c:forEach>
</table>
                
<div id="paging">
	<c:if test="${prevPage > 0 }">
		<a href="#" title="${prevPage }">[이전]</a>
	</c:if>
	
	<c:forEach var="i" begin="${firstPage }" end="${lastPage }">
		<c:choose>
			<c:when test="${param.curPage == i }">
				<span class="bbs-strong">${i }</span>
			</c:when>	
			<c:otherwise>	
				<a href="#" title="${i }">${i }</a>
			</c:otherwise>
		</c:choose>			
	</c:forEach>
	
	<c:if test="${nextPage > 0 }">	
		<a href="#" title="${nextPage }">[다음]</a>
	</c:if>
</div>

<div id="list-menu">
	<input type="button" value="새글쓰기" />
</div>

<div id="search">
	<form action="list" method="get">
	<p style="margin: 0;padding: 0;">
		<input type="hidden" name="boardCd" value="${param.boardCd }" />
		<input type="hidden" name="curPage" value="1" />
		<input type="text" name="searchWord" size="15" maxlength="30" />
		<input type="submit" value="검색" />
	</p>
	</form>
</div>

</div><!-- bbs 끝 -->
<!-- 본문 끝 -->

		</div><!-- content 끝 -->
	</div><!-- container 끝 -->
    
	<div id="sidebar">
		<%@ include file="bbs-menu.jsp" %>
	</div>
    
    <div id="extra">
    	<%@ include file="../inc/extra.jsp" %>
    </div>
    
    <div id="footer">
		<%@ include file="../inc/footer.jsp" %>
    </div>
        
</div>

<div id="form-group" style="display: none">
    <form id="listForm" action="list" method="get">
    <p>
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>
    <form id="viewForm" action="view" method="get">
    <p>
        <input type="hidden" name="articleNo" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>
    <form id="writeForm" action="write_form" method="get">
    <p>
        <input type="hidden" name="articleNo" value="${param.articleNo }" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>
    <form id="modifyForm" action="modify_form" method="get">
    <p>
        <input type="hidden" name="articleNo" value="${param.articleNo }" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>
    <form id="delForm" action="del" method="post">
    <p>
        <input type="hidden" name="articleNo" value="${param.articleNo }" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>
    <form id="deleteCommentForm" action="deleteComment" method="post">
    <p>
        <input type="hidden" name="commentNo" />
        <input type="hidden" name="articleNo" value="${param.articleNo }" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>   
    <form id="deleteAttachFileForm" action="deleteAttachFile" method="post">
    <p>
        <input type="hidden" name="attachFileNo" />
        <input type="hidden" name="articleNo" value="${param.articleNo }" />
        <input type="hidden" name="boardCd" value="${param.boardCd }" />
        <input type="hidden" name="curPage" value="${param.curPage }" />
        <input type="hidden" name="searchWord" value="${param.searchWord }" />
    </p>
    </form>
    <form id="downForm" action="download" method="post">
    <p>
        <input type="hidden" name="filename" />
    </p>
    </form>
</div>

</body>
</html>
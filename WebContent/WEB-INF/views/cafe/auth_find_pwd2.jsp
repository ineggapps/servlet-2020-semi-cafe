<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	String cp = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <!-- <meta name="viewport" content="width=device-width, initial-scale=1.0" /> -->
    <title>COFFEE</title>
    <link rel="stylesheet" href="<%=cp%>/resource/css/reset.css" />
    <link rel="stylesheet" href="<%=cp%>/resource/css/layout.css" />
    <link rel="stylesheet" href="<%=cp%>/resource/css/authentication.css" />
  
  <script type="text/javascript">
  function send_ok2(){
  	var f=document.findPwdForm;
  	
	if(f.userPwd.value != f.userPwdConfirm.value){
		alert("비밀번호란이 서로 일치하지 않습니다.");
		f.userPwd.focus();
		return;
	}
	
	if(!/^(?=.*[a-z])(?=.*[!@#$%^*+=-]|.*[0-9]).{5,10}$/i.test(f.userPwd.value)) { 
		alert("패스워드는 5~10자이며 하나 이상의 숫자나 특수문자가 포함되어야 합니다.");
		f.userPwd.focus();
		return;
	}
	

	f.submit();
	
  }
  </script>
  
  
  </head>
  <body>
    <div id="wrap">
      <header id="header">
      	<jsp:include page="/WEB-INF/views/layout/header.jsp"/>
      </header>
      <main id="content">
      	<form name="findPwdForm" action="<%=cp%>/auth/find_pwd_ok2.do" method="post">
        <div id="main">
          <article id="main_container">
            <!-- Content영역 -->
            <div class="row_full">
              <div class="row login">
                <h2><span>비밀번호 찾기</span></h2>
                <p class="welcome"><span>Cookie & Coffee</span></p>
                <p><span>쿠앤크커피에 오신 것을 환영합니다.</span></p>
              </div>

              <div class="row whitebox">
                <div class="row500">
                <table>
              
                <tr>
                	<td> <input  name="userPwd" class="text_input" type="password" placeholder="새 비밀번호" /> </td>
                </tr>
               
                <tr>
                     <td><input name="userPwdConfirm" class="text_input" type="password" placeholder="새 비밀번호 확인" /></td>
                </tr>
                
                <tr>
                    <td> 
                    	<input type="hidden" name="userId" value="${userId}"> 
                    	<input type="hidden" name="phone" value="${phone}">
                    	<button type="button" class="navy_button" onclick="send_ok2();">확인</button> </td>
                </tr>
                
                    <tr>
                   	<td colspan="2" align="center">
                    <ul class="login_menu">
                    	<li><a href="<%=cp%>/auth/join.do">회원가입</a></li>
                      	<li><a href="<%=cp%>/auth/login.do">로그인</a></li>
                    </ul>
                    </td>
                  </tr>
                </table>
                </div>
              </div>
            </div>

            <!-- Content 영역 끝 -->
          </article>
        </div>
      	</form>
      </main>
      <footer id="footer">
      	<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
      </footer>
    </div>
  </body>
</html>




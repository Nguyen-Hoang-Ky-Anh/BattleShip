<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/tmp/login.css">
</head>
<body>
<div class="container
    <%= "register".equals(request.getAttribute("mode"))
        ? "right-panel-active"
        : "" %>" id="container">
    <div class="form-container sign-up-container">
        <form action="login" method="post">
            <h1>Create Account</h1>
            <input type="text" name="username" placeholder="Name" required />
            <input type="email" name="email" placeholder="Email" required />
            <input type="password" name="password" placeholder="Password" required />
            <button style="background-color: #0f3460; border: none; cursor: pointer;"
                    onmouseover="this.style.backgroundColor='#3c97bf'"
                    onmouseout="this.style.backgroundColor='#0f3460'">
                Sign Up
            </button>
        </form>
    </div>
    <div class="form-container sign-in-container">
        <form action="login" method="post">
            <h1>Sign in</h1>
            <%
                String message = (String) request.getAttribute("message");
                if(message != null){
            %>
            <p style="color:red; margin:10px 0; font-size:13px;">
                <%= message %>
            </p>
            <%
                }
            %>
            <input type="text" name="user" placeholder="Email" required />
            <input type="password" name="password" placeholder="Password" required />
            <a href="#">Forgot your password?</a>
            <button style="background-color: #0f3460; border: none; cursor: pointer;"
                    onmouseover="this.style.backgroundColor='#3c97bf'"
                    onmouseout="this.style.backgroundColor='#0f3460'">
                Sign In
            </button>
        </form>
    </div>
    <div class="overlay-container">
        <div class="overlay" style="background: #0f3460">
            <div class="overlay-panel overlay-left">
                <h1>Welcome Back!</h1>
                <p>To keep connected with us please login with your personal info</p>
                <button class="ghost" id="signIn"
                        onmouseover="this.style.backgroundColor='#3c97bf'"
                        onmouseout="this.style.backgroundColor='#0f3460'">
                    Sign In
                </button>
            </div>
            <div class="overlay-panel overlay-right">
                <h1>Hello, Friend!</h1>
                <p>Enter your personal details and start journey with us</p>
                <button class="ghost" id="signUp"
                        onmouseover="this.style.backgroundColor='#3c97bf'"
                        onmouseout="this.style.backgroundColor='#0f3460'">
                    Sign Up
                </button>
            </div>
        </div>
    </div>
</div>

</body>
<script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
</html>

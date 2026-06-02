<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false displayInfo=true showMarketingPanel=false; section>

  <#if section = "header">
    Check your email
  <#elseif section = "subtitle">
    We've sent a verification link to your email address. Click the link to activate your account. If you don't see it, check your spam folder.
  <#elseif section = "form">

    <div class="ms-verify-icon">
      <svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
        <rect x="2" y="4" width="20" height="16" rx="2"/>
        <path d="M22 4L12 13 2 4"/>
      </svg>
    </div>

    <div class="ms-form-actions">
      <a href="${url.loginAction}" id="ms-resend-btn" class="ms-btn ms-btn--primary" style="text-align:center;" onclick="handleResend(event)">Resend verification email</a>
    </div>

    <script>
      function handleResend(e) {
        var btn = document.getElementById('ms-resend-btn');
        var href = btn.getAttribute('href');
        btn.textContent = 'Email sent!';
        btn.style.pointerEvents = 'none';
        btn.style.opacity = '0.7';
        setTimeout(function() {
          window.location.href = href;
        }, 1200);
        e.preventDefault();
      }
    </script>

  <#elseif section = "info">
    <a href="${url.loginUrl}" class="ms-back-link">
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
      Back to sign in
    </a>
  </#if>

</@layout.registrationLayout>

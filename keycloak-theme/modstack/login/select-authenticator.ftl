<#import "template.ftl" as layout>
<@layout.registrationLayout showMarketingPanel=false; section>

  <#if section = "header">
    Choose how to sign in
  <#elseif section = "subtitle">
    Select a verification method to continue
  <#elseif section = "form">

    <div class="ms-auth-methods">
      <#list auth.authenticationSelections as authSelection>
        <form action="${url.loginAction}" method="post">
          <input type="hidden" name="authenticationExecution" value="${authSelection.authExecId}">
          <button type="submit" class="ms-auth-method">
            <div class="ms-auth-method__icon">
              <#if authSelection.iconCssClass?? && authSelection.iconCssClass?has_content>
                <#if authSelection.iconCssClass?contains("password")>
                  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <#elseif authSelection.iconCssClass?contains("otp") || authSelection.iconCssClass?contains("authenticator")>
                  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="2" width="14" height="20" rx="2" ry="2"/><line x1="12" y1="18" x2="12.01" y2="18"/></svg>
                <#elseif authSelection.iconCssClass?contains("recovery")>
                  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>
                <#else>
                  <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
                </#if>
              <#else>
                <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
              </#if>
            </div>
            <div class="ms-auth-method__text">
              <span class="ms-auth-method__title">${msg('${authSelection.displayName}')}</span>
              <span class="ms-auth-method__desc">${msg('${authSelection.helpText}')}</span>
            </div>
            <svg class="ms-auth-method__arrow" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"/></svg>
          </button>
        </form>
      </#list>
    </div>

  </#if>

</@layout.registrationLayout>

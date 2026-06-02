<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=!messagesPerField.existsError('username','password') displayInfo=realm.password && realm.registrationAllowed && !registrationDisabled?? showMarketingPanel=true; section>

  <#if section = "header">
    Log in to your account
  <#elseif section = "subtitle">
    Enter your credentials to continue
  <#elseif section = "form">

    <#if realm.password>
      <form action="${url.loginAction}" method="post">

        <#-- Username / Email -->
        <div class="ms-form-group">
          <label for="username">
            <#if !realm.loginWithEmailAllowed>${msg("username")}<#elseif !realm.registrationEmailAsUsername>${msg("usernameOrEmail")}<#else>${msg("email")}</#if>
          </label>
          <input id="username" name="username" type="text" class="ms-input <#if messagesPerField.existsError('username','password')>ms-input--error</#if>" autocomplete="username" autofocus
            value="${(login.username!'')}" placeholder="you@company.com">
        </div>

        <#-- Password -->
        <div class="ms-form-group">
          <div class="ms-label-row">
            <label for="password">${msg("password")}</label>
            <#if realm.resetPasswordAllowed>
              <a href="${url.loginResetCredentialsUrl}">${msg("doForgotPassword")}</a>
            </#if>
          </div>
          <input id="password" name="password" type="password" class="ms-input <#if messagesPerField.existsError('username','password')>ms-input--error</#if>" autocomplete="current-password" placeholder="Enter your password">
        </div>

        <#-- Remember me -->
        <#if realm.rememberMe && !usernameHidden??>
          <div class="ms-checkbox">
            <input id="rememberMe" name="rememberMe" type="checkbox" <#if login.rememberMe??>checked</#if>>
            <label for="rememberMe">${msg("rememberMe")}</label>
          </div>
        </#if>

        <#-- Sign in button -->
        <div class="ms-form-actions">
          <input type="hidden" id="id-hidden-input" name="credentialId" <#if auth.selectedCredential?has_content>value="${auth.selectedCredential}"</#if>>
          <button type="submit" class="ms-btn ms-btn--primary">${msg("doLogIn")}</button>
        </div>

      </form>
    </#if>

    <#-- Social / Identity providers -->
    <#if realm.password && social?? && social.providers?has_content>
      <div class="ms-separator">or</div>
      <div class="ms-social-providers">
        <#list social.providers as p>
          <a href="${p.loginUrl}" class="ms-social-btn" id="social-${p.alias}">Continue with ${p.displayName!}</a>
        </#list>
      </div>
    </#if>

  <#elseif section = "info">
    <#if realm.password && realm.registrationAllowed && !registrationDisabled??>
      Don't have an account? <a href="${url.registrationUrl}">${msg("doRegister")}</a>
    </#if>
  </#if>

</@layout.registrationLayout>

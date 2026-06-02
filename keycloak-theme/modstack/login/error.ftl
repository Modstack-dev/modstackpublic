<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=false showMarketingPanel=false; section>

  <#if section = "header">
  <#elseif section = "subtitle">
  <#elseif section = "form">

    <div class="ms-error-header">
      <div class="ms-error-header__icon">
        <svg xmlns="http://www.w3.org/2000/svg" width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"/>
          <line x1="12" y1="8" x2="12" y2="12"/>
          <line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
      </div>
      <h2 class="ms-error-header__title">Something went wrong</h2>
    </div>

    <#if message?has_content>
      <div class="ms-alert ms-alert--error">
        ${kcSanitize(message.summary)?no_esc}
      </div>
    </#if>

    <#if client?? && client.baseUrl?has_content>
      <div class="ms-form-actions">
        <a href="${client.baseUrl}" class="ms-btn ms-btn--primary" style="text-align:center;">Back to application</a>
      </div>
    </#if>

  </#if>

</@layout.registrationLayout>

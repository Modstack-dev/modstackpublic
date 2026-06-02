<#macro registrationLayout bodyClass="" displayInfo=false displayMessage=true displayRequiredFields=false showMarketingPanel=true>
<!DOCTYPE html>
<html lang="${(locale.currentLanguageTag)!'en'}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>${msg("loginTitle",(realm.displayName!''))}</title>
  <#if properties.styles?has_content>
    <#list properties.styles?split(' ') as style>
      <link rel="stylesheet" href="${url.resourcesPath}/${style}">
    </#list>
  </#if>
</head>
<body>
  <div class="ms-split<#if !showMarketingPanel> ms-split--single</#if>">

    <#if showMarketingPanel>
    <div class="ms-panel">
      <svg class="ms-panel__pattern" viewBox="0 0 600 900" xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMidYMid slice">
        <defs>
          <pattern id="grid" width="60" height="60" patternUnits="userSpaceOnUse">
            <circle cx="30" cy="30" r="1.2" fill="rgba(255,255,255,0.13)"/>
          </pattern>
          <pattern id="diag" width="40" height="40" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">
            <line x1="0" y1="0" x2="0" y2="40" stroke="rgba(255,255,255,0.07)" stroke-width="1"/>
          </pattern>
          <radialGradient id="glow1" cx="70%" cy="30%" r="50%">
            <stop offset="0%" stop-color="rgba(255,255,255,0.10)"/>
            <stop offset="100%" stop-color="transparent"/>
          </radialGradient>
          <radialGradient id="glow2" cx="20%" cy="80%" r="40%">
            <stop offset="0%" stop-color="rgba(255,255,255,0.07)"/>
            <stop offset="100%" stop-color="transparent"/>
          </radialGradient>
        </defs>
        <rect width="600" height="900" fill="#333333"/>
        <rect width="600" height="900" fill="url(#grid)"/>
        <rect width="600" height="900" fill="url(#diag)"/>
        <rect width="600" height="900" fill="url(#glow1)"/>
        <rect width="600" height="900" fill="url(#glow2)"/>
        <circle cx="420" cy="200" r="120" fill="none" stroke="rgba(255,255,255,0.06)" stroke-width="1"/>
        <circle cx="420" cy="200" r="180" fill="none" stroke="rgba(255,255,255,0.04)" stroke-width="1"/>
        <circle cx="150" cy="650" r="100" fill="none" stroke="rgba(255,255,255,0.06)" stroke-width="1"/>
        <circle cx="150" cy="650" r="160" fill="none" stroke="rgba(255,255,255,0.04)" stroke-width="1"/>
      </svg>
    </div>
    </#if>

    <div class="ms-form-panel">
      <div class="ms-form-panel__inner">

        <div class="ms-form-panel__logo">
          <img src="${url.resourcesPath}/img/logo.svg" alt="${realm.displayName!''}">
        </div>

        <h1 class="ms-card__title"><#nested "header"></h1>
        <p class="ms-card__subtitle"><#nested "subtitle"></p>

        <#if displayMessage && message?has_content && (message.type != 'warning' || !isAppInitiatedAction??)>
          <div class="ms-alert ms-alert--${message.type}">
            ${kcSanitize(message.summary)?no_esc}
          </div>
        </#if>

        <#nested "form">

        <#if displayInfo>
          <div class="ms-form-footer">
            <#nested "info">
          </div>
        </#if>

      </div>
    </div>

  </div>
</body>
</html>
</#macro>

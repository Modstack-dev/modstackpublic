<#macro userProfileFormFields>
	<#assign currentGroup="">

	<#list profile.attributes as attribute>

		<#if attribute.name=='locale' && realm.internationalizationEnabled && (locale.currentLanguageTag)?has_content>
			<input type="hidden" id="${attribute.name}" name="${attribute.name}" value="${locale.currentLanguageTag}"/>
		<#else>

			<#assign group = (attribute.group)!"">
			<#if group != currentGroup>
				<#assign currentGroup=group>
				<#if currentGroup != "">
					<div class="ms-form-group"
					<#if group.html5DataAnnotations??>
					<#list group.html5DataAnnotations as key, value>
						data-${key}="${value}"
					</#list>
					</#if>
					>
						<#assign groupDisplayHeader=group.displayHeader!"">
						<#if groupDisplayHeader != "">
							<#assign groupHeaderText=advancedMsg(groupDisplayHeader)!group>
						<#else>
							<#assign groupHeaderText=group.name!"">
						</#if>
						<label class="ms-label" style="font-size:16px;font-weight:600;color:#1a1a1a;margin-bottom:12px;">${groupHeaderText}</label>

						<#assign groupDisplayDescription=group.displayDescription!"">
						<#if groupDisplayDescription != "">
							<#assign groupDescriptionText=advancedMsg(groupDisplayDescription)!"">
							<p style="font-size:13px;color:#888888;margin-bottom:12px;">${groupDescriptionText}</p>
						</#if>
					</div>
				</#if>
			</#if>

			<#nested "beforeField" attribute>
			<div class="ms-form-group">
				<label for="${attribute.name}">${advancedMsg(attribute.displayName!'')}<#if attribute.required> <span class="ms-required">*</span></#if></label>
				<#if attribute.annotations.inputHelperTextBefore??>
					<p style="font-size:12px;color:#888888;margin-bottom:6px;">${kcSanitize(advancedMsg(attribute.annotations.inputHelperTextBefore))?no_esc}</p>
				</#if>
				<@inputFieldByType attribute=attribute/>
				<#if messagesPerField.existsError('${attribute.name}')>
					<div class="ms-alert ms-alert--error" style="margin-top:6px;margin-bottom:0">
						${kcSanitize(messagesPerField.get('${attribute.name}'))?no_esc}
					</div>
				</#if>
				<#if attribute.annotations.inputHelperTextAfter??>
					<p style="font-size:12px;color:#888888;margin-top:6px;">${kcSanitize(advancedMsg(attribute.annotations.inputHelperTextAfter))?no_esc}</p>
				</#if>
			</div>
			<#nested "afterField" attribute>

		</#if>
	</#list>

	<#if profile.html5DataAnnotations??>
	<#list profile.html5DataAnnotations?keys as key>
		<script type="module" src="${url.resourcesPath}/js/${key}.js"></script>
	</#list>
	</#if>
</#macro>

<#macro inputFieldByType attribute>
	<#switch attribute.annotations.inputType!''>
	<#case 'textarea'>
		<@textareaTag attribute=attribute/>
		<#break>
	<#case 'select'>
	<#case 'multiselect'>
		<@selectTag attribute=attribute/>
		<#break>
	<#case 'select-radiobuttons'>
	<#case 'multiselect-checkboxes'>
		<@inputTagSelects attribute=attribute/>
		<#break>
	<#default>
		<#if attribute.multivalued && attribute.values?has_content>
			<#list attribute.values as value>
				<@inputTag attribute=attribute value=value!''/>
			</#list>
		<#else>
			<@inputTag attribute=attribute value=attribute.value!''/>
		</#if>
	</#switch>
</#macro>

<#macro inputTag attribute value>
	<input type="<@inputTagType attribute=attribute/>" id="${attribute.name}" name="${attribute.name}" value="${(value!'')}" class="ms-input <#if messagesPerField.existsError('${attribute.name}')>ms-input--error</#if>"
	aria-invalid="<#if messagesPerField.existsError('${attribute.name}')>true</#if>"
	<#if attribute.readOnly>disabled</#if>
	<#if attribute.autocomplete??>autocomplete="${attribute.autocomplete}"</#if>
	<#if attribute.name == 'email'>placeholder="you@example.com"</#if>
	<#if attribute.annotations.inputTypePlaceholder??>placeholder="${advancedMsg(attribute.annotations.inputTypePlaceholder)}"</#if>
	<#if attribute.annotations.inputTypePattern??>pattern="${attribute.annotations.inputTypePattern}"</#if>
	<#if attribute.annotations.inputTypeSize??>size="${attribute.annotations.inputTypeSize}"</#if>
	<#if attribute.annotations.inputTypeMaxlength??>maxlength="${attribute.annotations.inputTypeMaxlength}"</#if>
	<#if attribute.annotations.inputTypeMinlength??>minlength="${attribute.annotations.inputTypeMinlength}"</#if>
	<#if attribute.annotations.inputTypeMax??>max="${attribute.annotations.inputTypeMax}"</#if>
	<#if attribute.annotations.inputTypeMin??>min="${attribute.annotations.inputTypeMin}"</#if>
	<#if attribute.annotations.inputTypeStep??>step="${attribute.annotations.inputTypeStep}"</#if>
	<#if attribute.html5DataAnnotations??>
	<#list attribute.html5DataAnnotations as key, value>
		data-${key}="${value}"
	</#list>
	</#if>
	/>
</#macro>

<#macro inputTagType attribute>
	<#compress>
	<#if attribute.annotations.inputType??>
		<#if attribute.annotations.inputType?starts_with("html5-")>
			${attribute.annotations.inputType[6..]}
		<#else>
			${attribute.annotations.inputType}
		</#if>
	<#else>
	text
	</#if>
	</#compress>
</#macro>

<#macro textareaTag attribute>
	<textarea id="${attribute.name}" name="${attribute.name}" class="ms-input" style="height:auto;padding:12px 16px;min-height:80px;resize:vertical;"
	aria-invalid="<#if messagesPerField.existsError('${attribute.name}')>true</#if>"
	<#if attribute.readOnly>disabled</#if>
	<#if attribute.annotations.inputTypeCols??>cols="${attribute.annotations.inputTypeCols}"</#if>
	<#if attribute.annotations.inputTypeRows??>rows="${attribute.annotations.inputTypeRows}"</#if>
	<#if attribute.annotations.inputTypeMaxlength??>maxlength="${attribute.annotations.inputTypeMaxlength}"</#if>
	>${(attribute.value!'')}</textarea>
</#macro>

<#macro selectTag attribute>
	<select id="${attribute.name}" name="${attribute.name}" class="ms-input" style="cursor:pointer;appearance:none;background-image:url(&quot;data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23ffffff' stroke-width='2'%3E%3Cpolyline points='6 9 12 15 18 9'/%3E%3C/svg%3E&quot;);background-repeat:no-repeat;background-position:right 14px center;padding-right:40px;"
	aria-invalid="<#if messagesPerField.existsError('${attribute.name}')>true</#if>"
	<#if attribute.readOnly>disabled</#if>
	<#if attribute.annotations.inputType=='multiselect'>multiple</#if>
	<#if attribute.annotations.inputTypeSize??>size="${attribute.annotations.inputTypeSize}"</#if>
	>
	<#if attribute.annotations.inputType=='select'>
		<option value=""></option>
	</#if>

	<#if attribute.annotations.inputOptionsFromValidation?? && attribute.validators[attribute.annotations.inputOptionsFromValidation]?? && attribute.validators[attribute.annotations.inputOptionsFromValidation].options??>
		<#assign options=attribute.validators[attribute.annotations.inputOptionsFromValidation].options>
	<#elseif attribute.validators.options?? && attribute.validators.options.options??>
		<#assign options=attribute.validators.options.options>
	<#else>
		<#assign options=[]>
	</#if>

	<#list options as option>
		<option value="${option}" <#if attribute.values?seq_contains(option)>selected</#if>><@selectOptionLabelText attribute=attribute option=option/></option>
	</#list>
	</select>
</#macro>

<#macro inputTagSelects attribute>
	<#if attribute.annotations.inputType=='select-radiobuttons'>
		<#assign inputType='radio'>
	<#else>
		<#assign inputType='checkbox'>
	</#if>

	<#if attribute.annotations.inputOptionsFromValidation?? && attribute.validators[attribute.annotations.inputOptionsFromValidation]?? && attribute.validators[attribute.annotations.inputOptionsFromValidation].options??>
		<#assign options=attribute.validators[attribute.annotations.inputOptionsFromValidation].options>
	<#elseif attribute.validators.options?? && attribute.validators.options.options??>
		<#assign options=attribute.validators.options.options>
	<#else>
		<#assign options=[]>
	</#if>

	<#list options as option>
		<div class="ms-checkbox">
			<input type="${inputType}" id="${attribute.name}-${option}" name="${attribute.name}" value="${option}"
			aria-invalid="<#if messagesPerField.existsError('${attribute.name}')>true</#if>"
			<#if attribute.readOnly>disabled</#if>
			<#if attribute.values?seq_contains(option)>checked</#if>
			/>
			<label for="${attribute.name}-${option}"><@selectOptionLabelText attribute=attribute option=option/></label>
		</div>
	</#list>
</#macro>

<#macro selectOptionLabelText attribute option>
	<#compress>
	<#if attribute.annotations.inputOptionLabels??>
		${advancedMsg(attribute.annotations.inputOptionLabels[option]!option)}
	<#else>
		<#if attribute.annotations.inputOptionLabelsI18nPrefix??>
			${msg(attribute.annotations.inputOptionLabelsI18nPrefix + '.' + option)}
		<#else>
			${option}
		</#if>
	</#if>
	</#compress>
</#macro>

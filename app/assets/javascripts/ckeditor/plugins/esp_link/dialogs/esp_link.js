﻿CKEDITOR.dialog.add('esp_link',function(v){var w=CKEDITOR.plugins.esp_link;var x=function(){var a=this.getDialog(),popupFeatures=a.getContentElement('target','popupFeatures'),targetName=a.getContentElement('target','linkTargetName'),value=this.getValue();if(!popupFeatures||!targetName)return;popupFeatures=popupFeatures.getElement();popupFeatures.hide();targetName.setValue('');switch(value){case'frame':targetName.setLabel(v.lang.link.targetFrameName);targetName.getElement().show();break;case'popup':popupFeatures.show();targetName.setLabel(v.lang.link.targetPopupName);targetName.getElement().show();break;default:targetName.setValue(value);targetName.getElement().hide();break}};var y=function(){var a=this.getDialog(),partIds=['urlOptions','anchorOptions','emailOptions'],typeValue=this.getValue();if(typeValue=='url'){if(v.config.linkShowTargetTab)a.showPage('target')}else{a.hidePage('target')}for(var i=0;i<partIds.length;i++){var b=a.getContentElement('info',partIds[i]);if(!b)continue;b=b.getElement().getParent().getParent();if(partIds[i]==typeValue+'Options')b.show();else b.hide()}a.layout()};var z=/^javascript:/,emailRegex=/^mailto:([^?]+)(?:\?(.+))?$/,emailSubjectRegex=/subject=([^;?:@&=$,\/]*)/,emailBodyRegex=/body=([^;?:@&=$,\/]*)/,anchorRegex=/^#(.*)$/,urlRegex=/^((?:http|https|ftp|news):\/\/)?(.*)$/,selectableTargets=/^(_(?:self|top|parent|blank))$/,encodedEmailLinkRegex=/^javascript:void\(location\.href='mailto:'\+String\.fromCharCode\(([^)]+)\)(?:\+'(.*)')?\)$/,functionCallProtectedEmailLinkRegex=/^javascript:([^(]+)\(([^)]+)\)$/;var A=/\s*window.open\(\s*this\.href\s*,\s*(?:'([^']*)'|null)\s*,\s*'([^']*)'\s*\)\s*;\s*return\s*false;*\s*/;var B=/(?:^|,)([^=]+)=(\d+|yes|no)/gi;var C=function(f,g){var h=(g&&(g.data('cke-saved-href')||g.getAttribute('href')))||'',javascriptMatch,emailMatch,anchorMatch,urlMatch,retval={};if((javascriptMatch=h.match(z))){if(J=='encode'){h=h.replace(encodedEmailLinkRegex,function(a,b,c){return'mailto:'+String.fromCharCode.apply(String,b.split(','))+(c&&unescapeSingleQuote(c))})}else if(J){h.replace(functionCallProtectedEmailLinkRegex,function(a,b,c){if(b==K.name){retval.type='email';var d=retval.email={};var e=/[^,\s]+/g,paramQuoteRegex=/(^')|('$)/g,paramsMatch=c.match(e),paramsMatchLength=paramsMatch.length,paramName,paramVal;for(var i=0;i<paramsMatchLength;i++){paramVal=decodeURIComponent(unescapeSingleQuote(paramsMatch[i].replace(paramQuoteRegex,'')));paramName=K.params[i].toLowerCase();d[paramName]=paramVal}d.address=[d.name,d.domain].join('@')}})}}if(!retval.type){if((anchorMatch=h.match(anchorRegex))){retval.type='anchor';retval.anchor={};retval.anchor.name=retval.anchor.id=anchorMatch[1]}else if((emailMatch=h.match(emailRegex))){var j=h.match(emailSubjectRegex),bodyMatch=h.match(emailBodyRegex);retval.type='email';var k=(retval.email={});k.address=emailMatch[1];j&&(k.subject=decodeURIComponent(j[1]));bodyMatch&&(k.body=decodeURIComponent(bodyMatch[1]))}else if(h&&(urlMatch=h.match(urlRegex))){retval.type='url';retval.url={};retval.url.protocol=urlMatch[1];retval.url.url=urlMatch[2]}else retval.type='url'}if(g){var l=g.getAttribute('target');retval.target={};retval.adv={};if(!l){var m=g.data('cke-pa-onclick')||g.getAttribute('onclick'),onclickMatch=m&&m.match(A);if(onclickMatch){retval.target.type='popup';retval.target.name=onclickMatch[1];var n;while((n=B.exec(onclickMatch[2]))){if((n[2]=='yes'||n[2]=='1')&&!(n[1]in{height:1,width:1,top:1,left:1}))retval.target[n[1]]=true;else if(isFinite(n[2]))retval.target[n[1]]=n[2]}}}else{var o=l.match(selectableTargets);if(o)retval.target.type=retval.target.name=l;else{retval.target.type='frame';retval.target.name=l}}var p=this;var q=function(a,b){var c=g.getAttribute(b);if(c!==null)retval.adv[a]=c||''};q('advId','id');q('advLangDir','dir');q('advAccessKey','accessKey');retval.adv.advName=g.data('cke-saved-name')||g.getAttribute('name')||'';q('advLangCode','lang');q('advTabIndex','tabindex');q('advTitle','title');q('advContentType','type');CKEDITOR.plugins.esp_link.synAnchorSelector?retval.adv.advCSSClasses=getLinkClass(g):q('advCSSClasses','class');q('advCharset','charset');q('advStyles','style');q('advRel','rel')}var r=retval.anchors=[],item;if(CKEDITOR.plugins.esp_link.emptyAnchorFix){var s=f.document.getElementsByTag('a');for(i=0,count=s.count();i<count;i++){item=s.getItem(i);if(item.data('cke-saved-name')||item.hasAttribute('name'))r.push({name:item.data('cke-saved-name')||item.getAttribute('name'),id:item.getAttribute('id')})}}else{var t=new CKEDITOR.dom.nodeList(f.document.$.anchors);for(var i=0,count=t.count();i<count;i++){item=t.getItem(i);r[i]={name:item.getAttribute('name'),id:item.getAttribute('id')}}}if(CKEDITOR.plugins.esp_link.fakeAnchor){var u=f.document.getElementsByTag('img');for(i=0,count=u.count();i<count;i++){if((item=CKEDITOR.plugins.esp_link.tryRestoreFakeAnchor(f,u.getItem(i))))r.push({name:item.getAttribute('name'),id:item.getAttribute('id')})}}this._.selectedElement=g;return retval};var D=function(a,b){if(b[a])this.setValue(b[a][this.id]||'')};var E=function(a){return D.call(this,'target',a)};var F=function(a){return D.call(this,'adv',a)};var G=function(a,b){if(!b[a])b[a]={};b[a][this.id]=this.getValue()||''};var H=function(a){return G.call(this,'target',a)};var I=function(a){return G.call(this,'adv',a)};function unescapeSingleQuote(a){return a.replace(/\\'/g,'\'')}function escapeSingleQuote(a){return a.replace(/'/g,'\\$&')}var J=v.config.emailProtection||'';if(J&&J!='encode'){var K={};J.replace(/^([^(]+)\(([^)]+)\)$/,function(b,c,d){K.name=c;K.params=[];d.replace(/[^,\s]+/g,function(a){K.params.push(a)})})}function protectEmailLinkAsFunction(a){var b,name=K.name,params=K.params,paramName,paramValue;b=[name,'('];for(var i=0;i<params.length;i++){paramName=params[i].toLowerCase();paramValue=a[paramName];i>0&&b.push(',');b.push('\'',paramValue?escapeSingleQuote(encodeURIComponent(a[paramName])):'','\'')}b.push(')');return b.join('')}function protectEmailAddressAsEncodedString(a){var b,length=a.length,encodedChars=[];for(var i=0;i<length;i++){b=a.charCodeAt(i);encodedChars.push(b)}return'String.fromCharCode('+encodedChars.join(',')+')'}function getLinkClass(a){var b=a.getAttribute('class');return b?b.replace(/\s*(?:cke_anchor_empty|cke_anchor)(?:\s*$)?/g,''):''}var L=v.lang.common,linkLang=v.lang.link;return{title:linkLang.title,minWidth:350,minHeight:230,contents:[{id:'info',label:linkLang.info,title:linkLang.info,elements:[{id:'linkType',type:'select',label:linkLang.type,'default':'url',items:[[linkLang.toUrl,'url'],[linkLang.toAnchor,'anchor'],[linkLang.toEmail,'email']],onChange:y,setup:function(a){if(a.type)this.setValue(a.type)},commit:function(a){a.type=this.getValue()}},{type:'vbox',id:'urlOptions',children:[{type:'hbox',widths:['25%','75%'],children:[{id:'protocol',type:'select',label:L.protocol,'default':'http://',items:[['http://\u200E','http://'],['https://\u200E','https://'],['ftp://\u200E','ftp://'],['news://\u200E','news://'],[linkLang.other,'']],setup:function(a){if(a.url)this.setValue(a.url.protocol||'')},commit:function(a){if(!a.url)a.url={};a.url.protocol=this.getValue()}},{type:'text',id:'url',label:L.url,required:true,onLoad:function(){this.allowOnChange=true},onKeyUp:function(){this.allowOnChange=false;var a=this.getDialog().getContentElement('info','protocol'),url=this.getValue(),urlOnChangeProtocol=/^(http|https|ftp|news):\/\/(?=.)/i,urlOnChangeTestOther=/^((javascript:)|[#\/\.\?])/i;var b=urlOnChangeProtocol.exec(url);if(b){this.setValue(url.substr(b[0].length));a.setValue(b[0].toLowerCase())}else if(urlOnChangeTestOther.test(url))a.setValue('');this.allowOnChange=true},onChange:function(){if(this.allowOnChange)this.onKeyUp()},validate:function(){var a=this.getDialog();if(a.getContentElement('info','linkType')&&a.getValueOf('info','linkType')!='url')return true;if(this.getDialog().fakeObj)return true;var b=CKEDITOR.dialog.validate.notEmpty(linkLang.noUrl);return b.apply(this)},setup:function(a){this.allowOnChange=false;if(a.url)this.setValue(a.url.url);this.allowOnChange=true},commit:function(a){this.onChange();if(!a.url)a.url={};a.url.url=this.getValue();this.allowOnChange=false}}],setup:function(a){if(!this.getDialog().getContentElement('info','linkType'))this.getElement().show()}},{type:'button',id:'browse',hidden:'true',filebrowser:'info:url',label:v.lang.esp_link.browseServer}]},{type:'vbox',id:'anchorOptions',width:260,align:'center',padding:0,children:[{type:'fieldset',id:'selectAnchorText',label:linkLang.selectAnchor,setup:function(a){if(a.anchors.length>0)this.getElement().show();else this.getElement().hide()},children:[{type:'hbox',id:'selectAnchor',children:[{type:'select',id:'anchorName','default':'',label:linkLang.anchorName,style:'width: 100%;',items:[['']],setup:function(a){this.clear();this.add('');for(var i=0;i<a.anchors.length;i++){if(a.anchors[i].name)this.add(a.anchors[i].name)}if(a.anchor)this.setValue(a.anchor.name);var b=this.getDialog().getContentElement('info','linkType');if(b&&b.getValue()=='email')this.focus()},commit:function(a){if(!a.anchor)a.anchor={};a.anchor.name=this.getValue()}},{type:'select',id:'anchorId','default':'',label:linkLang.anchorId,style:'width: 100%;',items:[['']],setup:function(a){this.clear();this.add('');for(var i=0;i<a.anchors.length;i++){if(a.anchors[i].id)this.add(a.anchors[i].id)}if(a.anchor)this.setValue(a.anchor.id)},commit:function(a){if(!a.anchor)a.anchor={};a.anchor.id=this.getValue()}}],setup:function(a){if(a.anchors.length>0)this.getElement().show();else this.getElement().hide()}}]},{type:'html',id:'noAnchors',style:'text-align: center;',html:'<div role="label" tabIndex="-1">'+CKEDITOR.tools.htmlEncode(linkLang.noAnchors)+'</div>',focus:true,setup:function(a){if(a.anchors.length<1)this.getElement().show();else this.getElement().hide()}}],setup:function(a){if(!this.getDialog().getContentElement('info','linkType'))this.getElement().hide()}},{type:'vbox',id:'emailOptions',padding:1,children:[{type:'text',id:'emailAddress',label:linkLang.emailAddress,required:true,validate:function(){var a=this.getDialog();if(!a.getContentElement('info','linkType')||a.getValueOf('info','linkType')!='email')return true;var b=CKEDITOR.dialog.validate.notEmpty(linkLang.noEmail);return b.apply(this)},setup:function(a){if(a.email)this.setValue(a.email.address);var b=this.getDialog().getContentElement('info','linkType');if(b&&b.getValue()=='email')this.select()},commit:function(a){if(!a.email)a.email={};a.email.address=this.getValue()}},{type:'text',id:'emailSubject',label:linkLang.emailSubject,setup:function(a){if(a.email)this.setValue(a.email.subject)},commit:function(a){if(!a.email)a.email={};a.email.subject=this.getValue()}},{type:'textarea',id:'emailBody',label:linkLang.emailBody,rows:3,'default':'',setup:function(a){if(a.email)this.setValue(a.email.body)},commit:function(a){if(!a.email)a.email={};a.email.body=this.getValue()}}],setup:function(a){if(!this.getDialog().getContentElement('info','linkType'))this.getElement().hide()}}]},{id:'target',label:linkLang.target,title:linkLang.target,elements:[{type:'hbox',widths:['50%','50%'],children:[{type:'select',id:'linkTargetType',label:L.target,'default':'notSet',style:'width : 100%;','items':[[L.notSet,'notSet'],[linkLang.targetFrame,'frame'],[linkLang.targetPopup,'popup'],[L.targetNew,'_blank'],[L.targetTop,'_top'],[L.targetSelf,'_self'],[L.targetParent,'_parent']],onChange:x,setup:function(a){if(a.target)this.setValue(a.target.type||'notSet');x.call(this)},commit:function(a){if(!a.target)a.target={};a.target.type=this.getValue()}},{type:'text',id:'linkTargetName',label:linkLang.targetFrameName,'default':'',setup:function(a){if(a.target)this.setValue(a.target.name)},commit:function(a){if(!a.target)a.target={};a.target.name=this.getValue().replace(/\W/gi,'')}}]},{type:'vbox',width:'100%',align:'center',padding:2,id:'popupFeatures',children:[{type:'fieldset',label:linkLang.popupFeatures,children:[{type:'hbox',children:[{type:'checkbox',id:'resizable',label:linkLang.popupResizable,setup:E,commit:H},{type:'checkbox',id:'status',label:linkLang.popupStatusBar,setup:E,commit:H}]},{type:'hbox',children:[{type:'checkbox',id:'location',label:linkLang.popupLocationBar,setup:E,commit:H},{type:'checkbox',id:'toolbar',label:linkLang.popupToolbar,setup:E,commit:H}]},{type:'hbox',children:[{type:'checkbox',id:'menubar',label:linkLang.popupMenuBar,setup:E,commit:H},{type:'checkbox',id:'fullscreen',label:linkLang.popupFullScreen,setup:E,commit:H}]},{type:'hbox',children:[{type:'checkbox',id:'scrollbars',label:linkLang.popupScrollBars,setup:E,commit:H},{type:'checkbox',id:'dependent',label:linkLang.popupDependent,setup:E,commit:H}]},{type:'hbox',children:[{type:'text',widths:['50%','50%'],labelLayout:'horizontal',label:L.width,id:'width',setup:E,commit:H},{type:'text',labelLayout:'horizontal',widths:['50%','50%'],label:linkLang.popupLeft,id:'left',setup:E,commit:H}]},{type:'hbox',children:[{type:'text',labelLayout:'horizontal',widths:['50%','50%'],label:L.height,id:'height',setup:E,commit:H},{type:'text',labelLayout:'horizontal',label:linkLang.popupTop,widths:['50%','50%'],id:'top',setup:E,commit:H}]}]}]}]},{id:'advanced',label:linkLang.advanced,title:linkLang.advanced,elements:[{type:'vbox',padding:1,children:[{type:'hbox',widths:['45%','35%','20%'],children:[{type:'text',id:'advId',label:linkLang.id,setup:F,commit:I},{type:'select',id:'advLangDir',label:linkLang.langDir,'default':'',style:'width:110px',items:[[L.notSet,''],[linkLang.langDirLTR,'ltr'],[linkLang.langDirRTL,'rtl']],setup:F,commit:I},{type:'text',id:'advAccessKey',width:'80px',label:linkLang.acccessKey,maxLength:1,setup:F,commit:I}]},{type:'hbox',widths:['45%','35%','20%'],children:[{type:'text',label:linkLang.name,id:'advName',setup:F,commit:I},{type:'text',label:linkLang.langCode,id:'advLangCode',width:'110px','default':'',setup:F,commit:I},{type:'text',label:linkLang.tabIndex,id:'advTabIndex',width:'80px',maxLength:5,setup:F,commit:I}]}]},{type:'vbox',padding:1,children:[{type:'hbox',widths:['45%','55%'],children:[{type:'text',label:linkLang.advisoryTitle,'default':'',id:'advTitle',setup:F,commit:I},{type:'text',label:linkLang.advisoryContentType,'default':'',id:'advContentType',setup:F,commit:I}]},{type:'hbox',widths:['45%','55%'],children:[{type:'text',label:linkLang.cssClasses,'default':'',id:'advCSSClasses',setup:F,commit:I},{type:'text',label:linkLang.charset,'default':'',id:'advCharset',setup:F,commit:I}]},{type:'hbox',widths:['45%','55%'],children:[{type:'text',label:linkLang.rel,'default':'',id:'advRel',setup:F,commit:I},{type:'text',label:linkLang.styles,'default':'',id:'advStyles',validate:CKEDITOR.dialog.validate.inlineStyle(v.lang.common.invalidInlineStyle),setup:F,commit:I}]}]}]}],onShow:function(){var a=this.getParentEditor(),selection=a.getSelection(),element=null;if((element=w.getSelectedLink(a))&&element.hasAttribute('href'))selection.selectElement(element);else element=null;this.setupContent(C.apply(this,[a,element]))},onOk:function(){var d={},removeAttributes=[],data={},me=this,v=this.getParentEditor();this.commitContent(data);switch(data.type||'url'){case'url':var e=(data.url&&data.url.protocol!=undefined)?data.url.protocol:'http://',url=(data.url&&CKEDITOR.tools.trim(data.url.url))||'';d['data-cke-saved-href']=(url.indexOf('/')===0)?url:e+url;break;case'anchor':var f=(data.anchor&&data.anchor.name),id=(data.anchor&&data.anchor.id);d['data-cke-saved-href']='#'+(f||id||'');break;case'email':var g,email=data.email,address=email.address;switch(J){case'':case'encode':{var h=encodeURIComponent(email.subject||''),body=encodeURIComponent(email.body||'');var j=[];h&&j.push('subject='+h);body&&j.push('body='+body);j=j.length?'?'+j.join('&'):'';if(J=='encode'){g=['javascript:void(location.href=\'mailto:\'+',protectEmailAddressAsEncodedString(address)];j&&g.push('+\'',escapeSingleQuote(j),'\'');g.push(')')}else g=['mailto:',address,j];break}default:{var k=address.split('@',2);email.name=k[0];email.domain=k[1];g=['javascript:',protectEmailLinkAsFunction(email)]}}d['data-cke-saved-href']=g.join('');break}if(data.target){if(data.target.type=='popup'){var l=['window.open(this.href, \'',data.target.name||'','\', \''];var m=['resizable','status','location','toolbar','menubar','fullscreen','scrollbars','dependent'];var n=m.length;var o=function(a){if(data.target[a])m.push(a+'='+data.target[a])};for(var i=0;i<n;i++)m[i]=m[i]+(data.target[m[i]]?'=yes':'=no');o('width');o('left');o('height');o('top');l.push(m.join(','),'\'); return false;');d['data-cke-pa-onclick']=l.join('');removeAttributes.push('target')}else{if(data.target.type!='notSet'&&data.target.name)d.target=data.target.name;else removeAttributes.push('target');removeAttributes.push('data-cke-pa-onclick','onclick')}}if(data.adv){var p=function(a,b){var c=data.adv[a];if(c)d[b]=c;else removeAttributes.push(b)};p('advId','id');p('advLangDir','dir');p('advAccessKey','accessKey');if(data.adv['advName'])d['name']=d['data-cke-saved-name']=data.adv['advName'];else removeAttributes=removeAttributes.concat(['data-cke-saved-name','name']);p('advLangCode','lang');p('advTabIndex','tabindex');p('advTitle','title');p('advContentType','type');p('advCSSClasses','class');p('advCharset','charset');p('advStyles','style');p('advRel','rel')}d.href=d['data-cke-saved-href'];if(!this._.selectedElement){var q=v.getSelection(),ranges=q.getRanges(true);if(ranges.length==1&&ranges[0].collapsed){var r=new CKEDITOR.dom.text(data.type=='email'?data.email.address:d['data-cke-saved-href'],v.document);ranges[0].insertNode(r);ranges[0].selectNodeContents(r);q.selectRanges(ranges)}var s=new CKEDITOR.style({element:'a',attributes:d});s.type=CKEDITOR.STYLE_INLINE;s.apply(v.document)}else{var t=this._.selectedElement,href=t.data('cke-saved-href'),textView=t.getHtml();t.setAttributes(d);t.removeAttributes(removeAttributes);if(data.adv&&data.adv.advName&&CKEDITOR.plugins.esp_link.synAnchorSelector)t.addClass(t.getChildCount()?'cke_anchor':'cke_anchor_empty');if(href==textView||data.type=='email'&&textView.indexOf('@')!=-1){t.setHtml(data.type=='email'?data.email.address:d['data-cke-saved-href'])}delete this._.selectedElement}},onLoad:function(){if(!v.config.linkShowAdvancedTab)this.hidePage('advanced');if(!v.config.linkShowTargetTab)this.hidePage('target')},onFocus:function(){var a=this.getContentElement('info','linkType'),urlField;if(a&&a.getValue()=='url'){urlField=this.getContentElement('info','url');urlField.select()}}}});


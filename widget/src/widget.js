(function(){
  if (window.__chatboxWidget_v1) return; window.__chatboxWidget_v1 = true;

  const CFG = {
    apiBase: "https://api.adsandtracking.com",
    tenantId: "TENANT_ID",
    publicKey: "PUBLIC_KEY",
    name: "Rifat",
    subText: "Typically replies in a few hours",
    greetingHtml: "Hi there 🙂,<br>How can I help you?<br><b>To start chat, enter your email or phone</b>",
    buttonText: "Start Chat",
    avatarUrl: "https://adsandtracking.com/wp-content/uploads/2025/12/whatsapp_user.png",
    bgUrl: "https://adsandtracking.com/wp-content/uploads/2025/12/whatsapp-background.png",
    fabIconPng: "https://adsandtracking.com/wp-content/uploads/2025/12/WhatsApplogo-1.png",
    emailPlaceholder: "Enter your email or phone to start",
    msgPlaceholder: "Write your message",
    storageKey: "chatbox_session_v1",
    allowAnonymous: false
  };

  function qs(key){return new URLSearchParams(window.location.search).get(key)||"";}
  const utm = {
    gclid: qs("gclid"),
    fbclid: qs("fbclid"),
    utm_source: qs("utm_source"),
    utm_medium: qs("utm_medium"),
    utm_campaign: qs("utm_campaign"),
    utm_term: qs("utm_term"),
    utm_content: qs("utm_content"),
    referrer: document.referrer || "",
    landing_page: window.location.href
  };

  var css =
    ".cb-chat{position:fixed;right:22px;bottom:22px;z-index:999999;font-family:Inter,system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;}" +
    ".cb-fab{display:inline-flex;align-items:center;gap:10px;background:#1fbf5b;color:#fff;border:0;border-radius:999px;padding:12px 16px;cursor:pointer;box-shadow:0 18px 45px rgba(0,0,0,.18);}" +
    ".cb-panel{width:330px;max-width:calc(100vw - 44px);background:#fff;border-radius:14px;box-shadow:0 18px 45px rgba(0,0,0,.18);overflow:hidden;position:absolute;right:0;bottom:64px;opacity:0;visibility:hidden;transform:translateY(10px);transition:.18s ease;}" +
    ".cb-chat.is-open .cb-panel{opacity:1;visibility:visible;transform:translateY(0);}" +
    ".cb-header{display:flex;align-items:center;gap:12px;padding:12px;background:#1f2d3d;color:#fff;}" +
    ".cb-header-img img{width:42px;height:42px;border-radius:999px;object-fit:cover;}" +
    ".cb-header-name{font-weight:700;font-size:14px;line-height:1.1;}" +
    ".cb-header-sub{font-size:12px;color:rgba(255,255,255,.8);margin-top:2px;}" +
    ".cb-body{height:240px;padding:14px;background-image:url('" + CFG.bgUrl + "');background-size:cover;background-position:center;position:relative;}" +
    ".cb-body:after{content:'';position:absolute;inset:0;background:rgba(255,255,255,.68);}" +
    ".cb-bubble{position:relative;z-index:1;max-width:85%;background:#fff;border-radius:12px;padding:10px 12px;box-shadow:0 8px 20px rgba(0,0,0,.10);}" +
    ".cb-input{display:flex;gap:10px;padding:10px;background:#fff;border-top:1px solid rgba(0,0,0,.06);}" +
    ".cb-input-field{flex:1;border:1px solid rgba(0,0,0,.12);border-radius:999px;padding:10px 12px;font-size:13px;outline:none;}" +
    ".cb-send{width:42px;height:42px;border-radius:999px;border:0;cursor:pointer;background:#1fbf5b;color:#fff;font-size:16px;}";

  var styleEl=document.createElement("style");styleEl.appendChild(document.createTextNode(css));document.head.appendChild(styleEl);

  var root=document.createElement("div");root.className="cb-chat";root.id="cbChat";
  root.innerHTML =
  '<button class="cb-fab" type="button" id="cbOpenBtn" aria-label="Chat with us">' +
    '<span class="cb-fab-icon" aria-hidden="true"><img src="' + CFG.fabIconPng + '" alt="" style="width:20px;height:20px;"/></span>' +
    '<span class="cb-fab-text">' + CFG.buttonText + '</span></button>' +
  '<div class="cb-panel" role="dialog" aria-label="Chat popup">' +
    '<div class="cb-header">' +
      '<div class="cb-header-img"><img id="cbAvatar" alt="Support" /></div>' +
      '<div><div class="cb-header-name">' + CFG.name + '</div><div class="cb-header-sub">' + CFG.subText + '</div></div>' +
      '<button style="margin-left:auto;border:0;background:transparent;color:#fff;font-size:18px;cursor:pointer;" type="button" id="cbCloseBtn" aria-label="Close">✕</button>' +
    '</div>' +
    '<div class="cb-body">' +
      '<div class="cb-bubble"><div class="cb-bubble-name">' + CFG.name + '</div><div class="cb-bubble-text" id="cbBubbleText">' + CFG.greetingHtml + '</div><div class="cb-bubble-time" id="cbTime"></div></div>' +
    '</div>' +
    '<div class="cb-input">' +
      '<input id="cbMsg" class="cb-input-field" type="text" placeholder="' + CFG.emailPlaceholder + '" />' +
      '<button id="cbSendBtn" class="cb-send" type="button" aria-label="Send">➤</button>' +
    '</div>' +
  '</div>';
  document.body.appendChild(root);

  document.getElementById("cbAvatar").src = CFG.avatarUrl;
  const openBtn=document.getElementById("cbOpenBtn"), closeBtn=document.getElementById("cbCloseBtn"), sendBtn=document.getElementById("cbSendBtn"), msgInput=document.getElementById("cbMsg"), bubbleText=document.getElementById("cbBubbleText");
  let session = null; try{session=JSON.parse(localStorage.getItem(CFG.storageKey)||"null");}catch(e){}
  function setTime(){var d=new Date();var hh=String(d.getHours()).padStart(2,"0"),mm=String(d.getMinutes()).padStart(2,"0");var t=document.getElementById("cbTime");if(t)t.textContent=hh+":"+mm;} setTime();
  function open(){root.classList.add("is-open");setTime();setTimeout(()=>{try{msgInput&&msgInput.focus();}catch(e){}},50);} function close(){root.classList.remove("is-open");}
  openBtn&&openBtn.addEventListener("click",()=>root.classList.contains("is-open")?close():open()); closeBtn&&closeBtn.addEventListener("click",close);
  document.addEventListener("keydown",e=>{if(e.key==="Escape")close();});
  async function createSession(contact){
    const body=Object.assign({tenantId:CFG.tenantId, allowAnonymous:CFG.allowAnonymous}, utm, contact);
    const res=await fetch(CFG.apiBase+"/session",{method:"POST",headers:{"Content-Type":"application/json","X-Public-Key":CFG.publicKey},body:JSON.stringify(body)});
    if(!res.ok) throw new Error("session failed");
    return res.json(); // {conversationId, sessionToken}
  }
  async function sendMessage(text){
    if(!session){
      const contact = {};
      const v=text.trim();
      if (!CFG.allowAnonymous && !v) throw new Error("contact required");
      if (!CFG.allowAnonymous) {
        if (/@/.test(v)) contact.email=v; else contact.phone=v;
      }
      session = await createSession(contact);
      localStorage.setItem(CFG.storageKey, JSON.stringify(session));
      if (bubbleText) bubbleText.innerHTML = "✅ Contact saved.<br>Now type your message.";
      msgInput.placeholder = CFG.msgPlaceholder;
      msgInput.value = "";
      return;
    }
    const res=await fetch(CFG.apiBase+"/messages",{method:"POST",headers:{"Content-Type":"application/json","Authorization":"Bearer "+session.sessionToken},body:JSON.stringify({conversationId:session.conversationId, body:text})});
    if(!res.ok) throw new Error("send failed");
    msgInput.value="";
  }
  function handleSend(){
    const text=(msgInput&&msgInput.value||"").trim();
    if(!text) return;
    sendMessage(text).catch(()=>{msgInput.classList.add("cb-error");});
  }
  sendBtn&&sendBtn.addEventListener("click",handleSend);
  msgInput&&msgInput.addEventListener("keydown",e=>{if(e.key==="Enter")handleSend();});
})();

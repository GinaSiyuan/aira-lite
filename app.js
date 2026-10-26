/* Aira Lite — 网页体验版（中文）。与 SwiftUI 原型的 Lite 核心流一一对应。
   所有数据均为模拟；数字与 Model.swift 保持一致，贯穿解读 → 报告 → 计划。 */
"use strict";

/* ================= Icons (simple strokes, no SF Symbols) ================= */
const P = {
  spark:'M12 3l1.8 6.2L20 11l-6.2 1.8L12 19l-1.8-6.2L4 11l6.2-1.8z',
  check:'M5 12.5l4.5 4.5L19 7.5', chevron:'M9 5.5l7 6.5-7 6.5',
  close:'M6 6l12 12M18 6L6 18', plus:'M12 5v14M5 12h14',
  arrowUp:'M12 19V6M6.5 11.5L12 6l5.5 5.5', arrowRight:'M5 12h13M13 6.5L18.5 12 13 17.5',
  minus:'M6 12h12', info:'M12 11v6M12 7.2v.2',
  moon:'M19 14.5A8 8 0 0 1 9.5 5 8 8 0 1 0 19 14.5z',
  pulse:'M3 12h4l2.2-5 3.6 10L15 12h6',
  steps:'M5 17c0-2 1.4-3.4 3-3.4S11 15 11 17m2-6c0-2 1.4-3.4 3-3.4S19 9 19 11',
  breath:'M12 4c-2.5 3-4 5.6-4 8.4A4 4 0 0 0 12 20a4 4 0 0 0 4-7.6C14.7 9.6 13.4 7 12 4z',
  drop:'M12 4c-2.6 3.4-5 6.3-5 9.3A5 5 0 0 0 12 18.6a5 5 0 0 0 5-5.3C17 10.3 14.6 7.4 12 4z',
  home:'M4.5 11L12 4.5 19.5 11M6.3 9.8V19h11.4V9.8',
  plan:'M5 6.5h14v13H5zM5 10.5h14M9 4v4M15 4v4M9.5 15l2 2 3.5-3.6',
  clock:'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM12 7.5V12l3 2',
  recover:'M12 4v16M12 4c-4.5 0-7.5 2.6-8 6 2-1.4 3.8-1.8 5.4-1 1.1.5 1.8 1.4 2.6 1.4s1.5-.9 2.6-1.4c1.6-.8 3.4-.4 5.4 1-.5-3.4-3.5-6-8-6z',
  user:'M12 11.5a3.6 3.6 0 1 0 0-7.2 3.6 3.6 0 0 0 0 7.2zM4.8 19.6c1.3-3 4-4.6 7.2-4.6s5.9 1.6 7.2 4.6)',
  run:'M13.5 5.5a1.6 1.6 0 1 0 0-3.2 1.6 1.6 0 0 0 0 3.2zM6 20l3.4-5.2L8 10.4l4-2.4 2.4 3.4 3.6.8M10 20.6l1.4-3.8',
  bell:'M12 4a5.2 5.2 0 0 1 5.2 5.2c0 4 1.2 5.4 1.8 6H5c.6-.6 1.8-2 1.8-6A5.2 5.2 0 0 1 12 4zM10 18.6a2 2 0 0 0 4 0',
  lock:'M7 11h10v8H7zM9 11V8.5a3 3 0 0 1 6 0V11',
  refresh:'M19 12a7 7 0 1 1-2-4.9M17.5 4v3.3H14',
  flame:'M12 4c1 2.6 3.6 4 3.6 7.4A4.4 4.4 0 0 1 12 16a4.4 4.4 0 0 1-3.6-4.6C8.4 8 11 6.6 12 4z',
  stretch:'M12 6a1.6 1.6 0 1 0 0-3.2A1.6 1.6 0 0 0 12 6zM5 10l5-1.5 2 3 4-1 3 3.6M9.5 20l2.2-6 3 2 1.2 4',
  ask:'M12 21a9 9 0 1 0 0-18 9 9 0 0 0 0 18zM9.8 9.5A2.2 2.2 0 0 1 14 10c0 1.5-2 1.6-2 3.1M12 16.3v.2',
  walk:'M13 5.2a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3zM8 20l3-6-1-4.2 3.5-1 1.5 3.5 3 1M11.5 20l1.3-4',
  bike:'M6.5 17.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM17.5 17.5a3 3 0 1 0 0-6 3 3 0 0 0 0 6zM6.5 14.5L10 9h5l2.5 5.5M12 14.5L10 9',
  strength:'M4 12h16M7 8.5v7M17 8.5v7M9.6 12h4.8',
  swim:'M4 17c1.6 1.2 3.2 1.2 4.8 0s3.2-1.2 4.8 0 3.2 1.2 4.8 0M15 8.5a1.6 1.6 0 1 0 0-3.2 1.6 1.6 0 0 0 0 3.2zM5 13l5-4 3.4 2.4',
  rope:'M7 4c-2 5 0 7 3 9s4 5-1 7M17 4c2 5 0 7-3 9s-4 5 1 7',
  meditate:'M12 7a1.8 1.8 0 1 0 0-3.6A1.8 1.8 0 0 0 12 7zM12 9v4m0 0l-4.5 3.2M12 13l4.5 3.2M6 20h12',
  coffee:'M5 8h11v6a5 5 0 0 1-10 0V8zM16 9.5h2a2.3 2.3 0 0 1 0 4.6h-2.3M7.5 4.5c.6.8.6 1.4 0 2.2M11 4.5c.6.8.6 1.4 0 2.2',
  dance:'M13 4.8a1.6 1.6 0 1 0 0-3.2 1.6 1.6 0 0 0 0 3.2zM6 9.5L11 8l3 2.5 4-2M12 10.5l-2 5-3.4 4M13 14.5l2.4 5',
  read:'M12 6.5C10 5 7.5 4.6 4.5 5v13c3-0.4 5.5 0 7.5 1.5 2-1.5 4.5-1.9 7.5-1.5V5c-3-.4-5.5 0-7.5 1.5zM12 6.5V19.5',
};
function ic(name, size=16, w=1.8, color='currentColor', style=''){
  return `<svg class="icn" width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" style="flex:none;${style}"><path d="${P[name]||''}" stroke="${color}" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round"/></svg>`;
}

/* ================= Mock data (Model.swift) ================= */
const Mock = {
  selfCheck: [2.1, 2.8, 3.1, 3.6, 4.2, 3.4, null, 2.2, 2.9, 3.8, 4.1, 3.3, 2.4, 1.8],
};
/* ================= State (App in Model.swift) ================= */
const S = {
  phase:'welcome', entered:null, tab:0, profStep:0,
  nickname:'', age:32, sex:0, sessionBand:1, years:2,
  healthGranted:false, devices:new Set(), syncedItems:0,
  saliva:0, // 0 未安排 1 采样日 3 已寄出 4 T0 已出
  reopenT0:false, reopenFR:false,
  points:[
    {name:'醒来',        when:'06:45', hint:'睁眼后先别起身，留在床上取这一管', done:false},
    {name:'醒后 30 分钟', when:'07:15', hint:'和上一管对比，看你醒来后压力激素有没有正常升高', done:false},
    {name:'午饭前',      when:'11:30', hint:'吃饭前取，食物会干扰读数', done:false},
    {name:'下午',        when:'15:00', hint:'饭后至少 1 小时再取', done:false},
    {name:'睡前',        when:'23:30', hint:'这一管也用来看身体几点准备好入睡', done:false},
  ],
  stepIndex:0,
  sent:[], unread:1,
  selfSelected:13, loggedToday:false, feel:2,
  sheet:null, sheetArg:null,
  plan:{acc:new Set(), skip:new Set(), day:0, done:new Set()}, deckOpen:false,
};
const nick = () => S.nickname.trim() || 'Chloe';
const donePts = () => S.points.filter(p=>p.done).length;

/* 主界面的「今天」在 T0 出具之后；四周后复测 */
const TODAY = {label:'10月23日 周五', retest:'11月19日', daysLeft:27};
const WEEK = ['周五','周六','周日','周一','周二','周三','周四'].map((w,i)=>({w,date:23+i}));
const ALLDAYS=[0,1,2,3,4,5,6], WORKDAYS=[0,3,4,5,6];
/* 四周目标：由 T0 报告推出，11/19 复测验收 */
const TARGETS=[
  {id:'lat',   icon:'moon',    title:'躺下半小时内睡着',      now:'38 分钟',      goal:'20 分钟以内',      why:'睡前压力激素还没退下去'},
  {id:'tense', icon:'pulse',   title:'白天紧绷少半小时',      now:'每天近 2 小时', goal:'1 小时 20 分以内', why:'压力激素白天退不下去'},
  {id:'debt',  icon:'recover', title:'睡眠债还到 2 小时以内', now:'6 小时',       goal:'2 小时以内',       why:'修复类激素偏低，睡够是最直接的补法'},
];
/* 推荐活动：按影响排序，每条都带唾液 / 手表证据（why this） */
const ACTS=[
  {id:'wind', target:'lat', icon:'moon', tag:'入睡', col:'#B79BFF', impact:9.2, saliva:true,
   title:'23:00 后放下工作和手机', how:'不回工作消息，把灯调暗，做点放松的事', when:'每晚 23:00', time:'23:00', days:ALLDAYS,
   because:'你睡前的压力激素是正常范围的两倍多，难怪 30 晚里有 26 晚躺下半小时都睡不着。生物钟其实是准的，关键是让睡前的压力先退下去。',
   evidence:['睡前压力激素偏高，是正常的 2 倍多','平均躺下 38 分钟才睡着','生物钟是准的'], onset:'约 2 周，入睡用时开始缩短',
   why3:['入睡是你离目标最远的一项','唾液显示你睡前压力激素偏高','每晚只要提前收手机']},
  {id:'early', target:'debt', icon:'clock', tag:'睡眠债', col:'#7ACBFF', impact:8.6, saliva:true,
   title:'提前 30 分钟上床', how:'00:15 前躺下，周末也别晚于 01:00', when:'每晚 00:15', time:'00:15', days:ALLDAYS,
   because:'这一周你少睡了 6 个小时，负责修复的激素也偏低。多睡一会儿，是让身体缓过来最直接的办法。',
   evidence:['这一周少睡了 6 小时','修复激素偏低','睡觉时越来越难放松'], onset:'约 1 周睡眠债开始下降，修复激素到复测再看',
   why3:['睡眠债一周就攒了 6 小时','修复激素偏低，睡够最直接','只是早一点躺下']},
  {id:'walk', target:'tense', icon:'walk', tag:'白天紧绷', col:'#FFB85C', impact:7.8, saliva:true,
   title:'下午离开工位走 15 分钟', how:'下午 3 点左右，正是你最紧张的时候', when:'工作日 15:00', time:'15:00', days:WORKDAYS,
   because:'你白天最紧张的就是下午 2 点到 5 点，那管唾液里的压力激素也没按时降下来，而那会儿你通常连坐两个多小时。起来走走，把这段紧绷打断。',
   evidence:['下午 2 点到 5 点最紧张','下午压力激素偏高','常常连坐 2 个多小时'], onset:'约 1 周，下午的紧绷时长会变短',
   why3:['正好卡在你最紧张的时段','手表和唾液都指向下午','需要从工位离开，稍难坚持']},
  {id:'breath', target:'lat', icon:'meditate', tag:'入睡', col:'#B79BFF', impact:7.1, saliva:false,
   title:'睡前 10 分钟缓慢呼吸', how:'躺下后，呼气比吸气长一倍', when:'工作日 23:50', time:'23:50', days:WORKDAYS,
   because:'躺下后你的心跳比平时快，慢慢呼气能让它更快降下来。和「23:00 后放下工作和手机」一起做，效果更好。',
   evidence:['躺下后心跳比平时快','平均躺下 38 分钟才睡着'], onset:'当晚就能感到，2 周看入睡用时',
   why3:['和「放下工作和手机」一起用效果更好','目前只有手表数据支持','需要每晚记得做']},
];
const targetOf = id => TARGETS.find(t=>t.id===id);
const actsFor = id => ACTS.filter(a=>a.target===id && S.plan.acc.has(a.id));
const timeKey = t => { const [h,m]=t.split(':').map(Number); return (h<5?h+24:h)*60+m; };
const dayItems = d => ACTS.filter(a=>S.plan.acc.has(a.id)&&a.days.includes(d))
  .map(a=>({key:a.id,title:a.title,time:a.time,icon:a.icon,col:a.col,how:a.how,tag:a.tag}))
  .sort((x,y)=>timeKey(x.time)-timeKey(y.time));

function reset(){
  Object.assign(S,{phase:'welcome',entered:null,tab:0,profStep:0,nickname:'',healthGranted:false,syncedItems:0,
    saliva:0,reopenT0:false,reopenFR:false,stepIndex:0,sent:[],typing:null,fresh:false,unread:1,
    loggedToday:false,sheet:null});
  S.devices.clear();
  S.points.forEach(p=>p.done=false);
  S.plan.acc.clear(); S.plan.skip.clear(); S.plan.done.clear(); S.plan.day=0; S.deckOpen=false;
}

/* ================= Tiny chart builders (SVG) ================= */
function smoothPath(pts){
  if(!pts.length) return '';
  let d=`M${pts[0][0].toFixed(1)} ${pts[0][1].toFixed(1)}`;
  for(let i=1;i<pts.length;i++){
    const cx=((pts[i-1][0]+pts[i][0])/2).toFixed(1);
    d+=` C${cx} ${pts[i-1][1].toFixed(1)} ${cx} ${pts[i][1].toFixed(1)} ${pts[i][0].toFixed(1)} ${pts[i][1].toFixed(1)}`;
  }
  return d;
}
function cortisolSketch(w=300,h=70){
  const pts=[0.46,0.62,0.34,0.26,0.22], ideal=[0.52,0.92,0.42,0.22,0.08];
  const X=i=>w*i/4, Y=v=>h*(1-v)*0.86+4;
  const p1=smoothPath(pts.map((v,i)=>[X(i),Y(v)])), p2=smoothPath(ideal.map((v,i)=>[X(i),Y(v)]));
  return `<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">
    <path d="${p2}" stroke="rgba(255,255,255,.26)" stroke-width="1.4" stroke-dasharray="3 3" fill="none"/>
    <path d="${p1}" stroke="var(--lime)" stroke-width="2.2" fill="none" stroke-linecap="round"/>
    <circle r="9" fill="rgba(220,245,90,.25)" style="offset-path:path('${p1}');animation:dotmove 4.6s ease-in-out infinite alternate"></circle>
    <circle r="4" fill="#fff" style="offset-path:path('${p1}');animation:dotmove 4.6s ease-in-out infinite alternate"></circle>
    <style>@keyframes dotmove{from{offset-distance:0%}to{offset-distance:100%}}</style></svg>`;
}
function comb(count, filled, h=26, ghostFrom=null){
  const on=Math.round(count*filled);
  let s=`<div class="comb" style="height:${h}px">`;
  for(let i=0;i<count;i++){
    const cls = ghostFrom!=null && i>=ghostFrom ? 'ghost' : (i<on?'on':'');
    s+=`<i class="${cls}"></i>`;
  }
  return s+`</div>`;
}
function neonBar(pct){
  return `<div style="height:5px;border-radius:99px;background:rgba(255,255,255,.14);overflow:hidden">
    <div style="height:100%;width:${pct}%;border-radius:99px;background:linear-gradient(90deg,#aebf4a,var(--lime2));
         box-shadow:0 0 10px rgba(214,255,60,.8);transition:width .12s linear"></div></div>`;
}
function textSphere(size=200,count=46,id=''){
  const letters='AIRA'; let s=`<div ${id?`id="${id}"`:''} style="position:relative;width:${size}px;height:${size}px;margin:0 auto">`;
  s+=`<div style="position:absolute;inset:18%;border-radius:50%;background:radial-gradient(circle,rgba(220,245,90,.35),transparent 70%);filter:blur(10px)"></div>`;
  let seed=7;
  const rnd=()=>{seed=(seed*16807)%2147483647;return seed/2147483647;};
  for(let i=0;i<count;i++){
    const a=rnd()*Math.PI*2, r=Math.pow(rnd(),0.6)*0.46;
    const x=50+Math.cos(a)*r*100, y=50+Math.sin(a)*r*100;
    const ch=letters[i%4], fs=8+rnd()*10, op=0.25+rnd()*0.7;
    const col=rnd()>0.72?'var(--lime)':'#fff';
    s+=`<span style="position:absolute;left:${x.toFixed(1)}%;top:${y.toFixed(1)}%;font-size:${fs.toFixed(0)}px;
        font-weight:600;color:${col};opacity:${op.toFixed(2)};--fx:${(rnd()*8-4).toFixed(1)}px;--fy:${(rnd()*8-4).toFixed(1)}px;
        animation:floatLetter ${(2.4+rnd()*2.6).toFixed(1)}s ease-in-out ${(rnd()*2).toFixed(1)}s infinite">${ch}</span>`;
  }
  return s+'</div>';
}
function face(level, size=24, color='#6B6B6E', lw=1.7){
  const L=(a,t)=>{const x=Math.max(0,Math.min(a.length-1,t)),i=Math.floor(x),f=x-i;
    return i>=a.length-1?a[a.length-1]:a[i]+(a[i+1]-a[i])*f;};
  const bi=L([-2,-1,0,3,5],level), bo=L([-2,-1,0,-1,-3],level), m=L([7,4,0,-4,-7],level);
  const u=size/40;
  const my=(27-m*0.22)*u, mc=(27+m*0.78)*u;
  return `<svg class="facesvg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
   <circle cx="${20*u}" cy="${20*u}" r="${15*u}" stroke="${color}" stroke-width="${lw}" fill="none"/>
   <path d="M${11*u} ${(15+bi)*u}L${16*u} ${(15+bo)*u}M${29*u} ${(15+bi)*u}L${24*u} ${(15+bo)*u}" stroke="${color}" stroke-width="${lw}" stroke-linecap="round"/>
   <ellipse cx="${15.5*u}" cy="${20*u}" rx="${1.3*u}" ry="${1.5*u}" fill="${color}"/>
   <ellipse cx="${24.5*u}" cy="${20*u}" rx="${1.3*u}" ry="${1.5*u}" fill="${color}"/>
   <path d="M${14*u} ${my}Q${20*u} ${mc} ${26*u} ${my}" stroke="${color}" stroke-width="${lw}" fill="none" stroke-linecap="round"/></svg>`;
}
const faceNames=['平静','还好','有点紧','紧绷','很紧绷'];

function selfTrend(){
  const vals=Mock.selfCheck, n=vals.length;
  const w=352,hh=120,pl=14,pr=14,top=18,bot=24;
  const X=i=>pl+(w-pl-pr)*i/(n-1), Y=v=>top+(hh-top-bot)*(1-(v-1)/3.4);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${hh}" style="display:block">`;
  s+=`<text x="${pl}" y="12" fill="var(--ink3)" font-size="9">紧绷</text>
      <text x="${pl}" y="${hh-2}" fill="var(--ink3)" font-size="9">平静</text>
      <text x="${w-pr}" y="${hh-2}" fill="var(--ink3)" font-size="9" text-anchor="end">10/23</text>
      <text x="${pl+34}" y="${hh-2}" fill="var(--ink3)" font-size="9">10/10</text>`;
  const pts=vals.map((v,i)=>v!=null?[X(i),Y(v)]:null);
  let seg=[]; const segs=[];
  pts.forEach(p=>{ if(p) seg.push(p); else if(seg.length){segs.push(seg);seg=[];} });
  if(seg.length)segs.push(seg);
  segs.forEach(sg=>{ s+=`<path d="${smoothPath(sg)}" stroke="var(--hair)" stroke-width="1.6" fill="none"/>`; });
  s+='</svg>';
  let faces='';
  vals.forEach((v,i)=>{ if(v==null)return;
    const selectedI = i===S.selfSelected;
    faces+=`<button data-self="${i}" style="position:absolute;left:calc(${(X(i)/w*100).toFixed(2)}% - 11px);
      top:${(Y(v)-11).toFixed(0)}px;width:24px;height:24px;border-radius:50%;
      background:${selectedI?'var(--lime)':'#fff'};border:1px solid ${selectedI?'var(--lime)':'var(--hair)'};
      display:flex;align-items:center;justify-content:center;box-shadow:0 1px 4px rgba(0,0,0,.08)">
      ${face(v-1,17,'#3c3c40',1.5)}</button>`;});
  return `<div style="position:relative">${s}${faces}</div>`;
}
/* ================= Shared UI bits ================= */
function cardHead(icon,title,sub,chip=null,chipTone='warn',trailing=''){
  const tones={good:'var(--lime)',warn:'var(--coral)',off:'var(--onD3)',sky:'var(--sky)'};
  return `<div class="cardhead">
    <div class="ibadge">${ic(icon,16,1.7,'#fff')}</div>
    <div class="tt"><div class="a">${title}</div><div class="b">${sub}</div></div>
    ${chip?`<span class="chip"><span class="dot" style="background:${tones[chipTone]};box-shadow:0 0 4px ${tones[chipTone]}"></span>${chip}</span>`:''}
    ${trailing}</div>`;
}
function chipEl(text,tone='good'){
  const tones={good:'var(--lime)',warn:'var(--coral)',off:'var(--onD3)',sky:'var(--sky)'};
  return `<span class="chip"><span class="dot" style="background:${tones[tone]};box-shadow:0 0 4px ${tones[tone]}"></span>${text}</span>`;
}
function qualifier(head,body,action=null,act=''){
  return `<div class="qualifier"><div class="h">存疑 · ${head}</div><div class="b">${body}</div>
    ${action?`<button class="act" ${act}>↳ ${action} ${ic('arrowRight',10,2.2,'var(--sky)')}</button>`:''}</div>`;
}
function cta(title,action,extra=''){
  return `<button class="cta ${extra}" ${action}><span class="t">${title}</span>
    <span class="knob">${ic('arrowRight',15,2.2,'#fff')}</span></button>`;
}
function sectionLabel(t){ return `<div class="sectionlabel">${t}</div>`; }

/* ================= Cards shared between Recap / Home / Agent ================= */
/* ================= Screens ================= */
const $screen=document.getElementById('screen');
const $sheet=document.getElementById('sheet');
const $veil=document.getElementById('sheetveil');

let lastKey=null;
function render(){
  let html='';
  switch(S.phase){
    case 'welcome': html=vWelcome(); break;
    case 'connect': html=vConnect(); break;
    case 'syncing': html=vLoading('sync'); break;
    case 'frintro': html=vIntro('fr'); break;
    case 'profile': html=vProfile(); break;
    case 'saliva':  html=vSaliva(); break;
    case 'collect': html=vCollect(); break;
    case 'waiting': html=vWaiting(); break;
    case 'analyzing': html=vLoading('analyze'); break;
    case 't0intro': html=vIntro('t0'); break;
    case 'main':    html=vMain(); break;
    // firstread / t0：报告页由 #frhost / #t0host 里的 iframe 承载
  }
  const key=S.phase+':'+S.tab, prev=$screen.querySelector('.scroll');
  const keepTop=(key===lastKey&&prev)?prev.scrollTop:null;
  $screen.innerHTML=html;
  if(keepTop!==null){
    const v=$screen.querySelector('.view'); if(v) v.style.animation='none';
    const sc=$screen.querySelector('.scroll'); if(sc) sc.scrollTop=keepTop;
  }
  lastKey=key;
  const fh=document.getElementById('frhost'), frOpen=S.phase==='firstread'&&S.reopenFR;
  fh.classList.toggle('show', S.phase==='firstread'); fh.classList.toggle('reopen', frOpen);
  try{ const fb=document.getElementById('frframe').contentDocument.body; fb.classList.toggle('closable', frOpen); fb.dataset.cta=frOpen?'回到首页':'继续'; }catch(e){}
  const t0=document.getElementById('t0host');
  t0.classList.toggle('show', S.phase==='t0');
  t0.classList.toggle('reopen', S.phase==='t0' && S.reopenT0);
  try{ document.getElementById('t0frame').contentDocument.body.classList.toggle('closable', S.phase==='t0' && S.reopenT0); }catch(e){}
  if(S.phase!==S.entered){
    S.entered=S.phase;
    if(S.phase==='firstread') reportGo('frframe',0);
    if(S.phase==='t0') reportGo('t0frame',0);
  }
  wireScreen();
  renderDemo();
  if(S.phase==='main'&&S.tab===1){
    const sc=document.getElementById('threadscroll');
    if(sc) sc.scrollTop=sc.scrollHeight;
  }
}
let toastT=null;
function toast(msg){
  const t=document.getElementById('toast'); if(!t) return;
  t.innerHTML=`${ic('check',12,2.6,'var(--ink)')}<span>${msg}</span>`;
  t.classList.add('show'); clearTimeout(toastT); toastT=setTimeout(()=>t.classList.remove('show'),1600);
}
function celebrate(d,n){
  const c=document.getElementById('cele'); if(!c) return;
  const conf=[...Array(26)].map((_,i)=>{ const a=i/26*Math.PI*2+Math.random()*.3, r=90+Math.random()*70;
    return `<i style="--x:${Math.cos(a)*r}px;--y:${Math.sin(a)*r}px;--r:${Math.random()*360}deg;background:${['#DCF55A','#FFB85C','#7ACBFF','#B79BFF'][i%4]};animation-delay:${.15+Math.random()*.1}s"></i>`; }).join('');
  c.innerHTML=`<div class="cb">
    <div class="burst">${conf}</div>
    <svg width="104" height="104" viewBox="0 0 104 104"><circle class="cr" cx="52" cy="52" r="46"/><path class="cm" d="M33 53 L46 66 L72 39"/></svg>
    <div class="t1">${d===0?'今天':WEEK[d].w}的 ${n} 件事，全部完成</div>
    <div class="t2">Well done · 本轮第 1 周</div></div>`;
  c.classList.add('show'); clearTimeout(celeT); celeT=setTimeout(()=>c.classList.remove('show'),2600);
}
let celeT=null;
function reportGo(id,i){ try{ document.getElementById(id).contentWindow.goTo(i); }catch(e){} }

/* ---- 1 Welcome ---- */
function vWelcome(){
  return `<div class="view"><div class="fogscreen warm"></div>
  <div style="position:relative;display:flex;flex-direction:column;height:100%;padding:0 22px;
       padding-top:max(20px, env(safe-area-inset-top));padding-bottom:max(16px, env(safe-area-inset-bottom))">
    <div class="row" style="justify-content:space-between;padding-top:4px">
      <span style="font-size:12px;font-weight:700;letter-spacing:4px;color:rgba(255,255,255,.9)">A I R A</span>
      <span style="font-size:10px;font-weight:600;letter-spacing:1px;color:rgba(255,255,255,.75);
            padding:5px 9px;border-radius:99px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.14)">抢先体验</span></div>
    <div style="flex:1 0 10px"></div>
    <div class="appearup" style="position:relative;padding-right:56px">
      <div class="glass" style="border-radius:20px;padding:14px">
        <div class="row" style="gap:8px"><span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
          <span style="font-size:9.5px;font-weight:700;letter-spacing:2px;color:rgba(255,255,255,.55)">压力激素 · 一天里的变化</span>
          <span style="margin-left:auto;font-size:9px;color:rgba(255,255,255,.35)">ng/mL</span></div>
        <div style="margin-top:10px">${cortisolSketch()}</div>
        <div class="row" style="justify-content:space-between;margin-top:8px">
          ${['醒来','+30 分','午饭前','下午','睡前'].map(t=>`<span style="font-size:8.5px;color:rgba(255,255,255,.4)">${t}</span>`).join('')}</div>
        <div class="row" style="gap:12px;margin-top:9px;font-size:9px;color:rgba(255,255,255,.5)">
          <span class="row" style="gap:5px"><i style="width:12px;height:2px;border-radius:2px;background:var(--lime)"></i>你的一天</span>
          <span class="row" style="gap:5px"><i style="width:12px;border-top:1.4px dashed rgba(255,255,255,.4)"></i>正常应该是这样</span></div>
      </div>
      <div style="position:absolute;right:0;top:20px;display:flex;flex-direction:column;gap:7px;align-items:flex-end">
        <div class="glass" style="border-radius:14px;padding:7px 10px;color:#fff">
          <div class="row" style="gap:2px"><span class="num" style="font-size:16px">48</span>
            <span style="font-size:9px;color:rgba(255,255,255,.5)">ms</span>
            <span style="color:var(--coral);font-size:9px">↓</span></div>
          <div style="font-size:9px;color:rgba(255,255,255,.45)">HRV</div></div>
        <div class="glass" style="border-radius:14px;padding:7px 10px;color:#fff">
          <div class="row" style="gap:2px"><span class="num" style="font-size:16px">6:31</span>
            <span style="color:var(--coral);font-size:9px">↓</span></div>
          <div style="font-size:9px;color:rgba(255,255,255,.45)">睡眠</div></div></div>
    </div>
    <div style="flex:1 0 10px"></div>
    <div class="serif appearup" style="font-size:34px;font-weight:600;color:#fff;line-height:1.3">压力不只是<br>一种感觉。</div>
    <div class="serif appearup" style="font-size:34px;font-weight:500;color:var(--lime);line-height:1.35">它可以被测出来。</div>
    <p class="appearup zh-loose" style="font-size:12.5px;color:rgba(255,255,255,.58);margin-top:10px">
      Aira 把你的手表数据和一天的唾液放在一起看，告诉你最近为什么累，接下来四周该怎么调整。</p>
    <div style="flex:1 0 8px"></div>
    <div style="display:flex;flex-direction:column;gap:13px">
      ${[['你的可穿戴设备','Apple Health、Oura、WHOOP · 近 30 天',
          `<span style="position:relative;width:88px;height:36px;display:inline-block">
            <img src="Assets/appicon_whoop.png" style="position:absolute;left:46px;top:3px;width:30px;border-radius:8px;transform:rotate(10deg)">
            <img src="Assets/appicon_oura.png" style="position:absolute;left:26px;top:-2px;width:31px;border-radius:8px;transform:rotate(-3deg)">
            <img src="Assets/appicon_health.png" style="position:absolute;left:4px;top:2px;width:33px;border-radius:8px;transform:rotate(-9deg);box-shadow:0 3px 8px rgba(0,0,0,.3)">
          </span>`],
         ['一次唾液采样','一天五管，在家完成',
          `<span style="width:88px;display:flex;justify-content:center">
            <span style="width:40px;height:40px;border-radius:10px;background:#f2f4ea;display:flex;align-items:center;justify-content:center;transform:rotate(-5deg);box-shadow:0 3px 8px rgba(0,0,0,.25)">${ic('drop',22,1.8,'#7a8f3a')}</span></span>`],
         ['一份完整解读','你为什么累，接下来四周怎么调整',
          `<span style="width:88px;display:flex;justify-content:center">
            <span style="width:40px;height:40px;border-radius:10px;background:#f4f2ec;display:flex;align-items:center;justify-content:center;transform:rotate(4deg);box-shadow:0 3px 8px rgba(0,0,0,.25)">${ic('plan',22,1.6,'#5d6b2f')}</span></span>`]
       ].map((r,i)=>`<div class="row appearup" style="gap:14px;animation-delay:${0.18+i*0.09}s">${r[2]}
          <div><div style="font-size:13.5px;font-weight:600;color:#fff">${r[0]}</div>
          <div style="font-size:11px;color:rgba(255,255,255,.48);margin-top:2px">${r[1]}</div></div></div>`).join('')}
    </div>
    <div style="margin-top:16px">${cta('开始使用','data-act="getstarted"')}</div>
  </div></div>`;
}

/* ---- 2 Connect ---- */
function onbTop(step,total,backAct){
  return `<div class="onb-top">
    <button class="onb-back" ${backAct}>${ic('chevron',13,2.2,'var(--ink)','transform:rotate(180deg)')}</button>
    <div class="onb-bar"><i style="width:${(step+1)/total*100}%"></i></div>
    <span class="onb-step">${step+1}/${total}</span></div>`;
}
function vConnect(){
  const types=[['moon','睡眠','几点睡、睡多久、睡得断不断'],
    ['pulse','心率变异性（HRV）','睡觉时身体放松得怎么样'],
    ['pulse','心率','坐着不动时能不能降下来'],
    ['steps','步数与运动','动了多少、什么时候动'],
    ['breath','呼吸与腕温','身体有没有在生病']];
  const wearables=[['appicon_oura','Oura Ring'],['appicon_whoop','WHOOP'],['appicon_garmin','Garmin']];
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(1,2,'data-act="backprof"')}
    <h2>连接你的数据</h2>
    <div class="sub">Aira 读取你最近 30 天的 Apple Health，马上给你第一份解读。</div>
    <div class="body">
      <button class="wcard ${S.healthGranted?'on':''}" data-act="grant" style="display:flex;align-items:center;gap:13px;width:100%;padding:15px;text-align:left">
        <img src="Assets/appicon_health.png" style="width:48px;border-radius:12px">
        <div style="flex:1"><div style="font-size:15px;font-weight:600">Apple Health</div>
          <div style="font-size:11.5px;color:${S.healthGranted?'var(--ink2)':'var(--ink3)'};margin-top:2px">
            ${S.healthGranted?'已连接 · 5 类数据':'只读，不会改动你的数据'}</div></div>
        ${S.healthGranted?`<span style="width:28px;height:28px;border-radius:50%;background:var(--lime);display:flex;align-items:center;justify-content:center">${ic('check',15,2.4,'var(--ink)')}</span>`:''}
      </button>
      ${S.healthGranted?`<div class="wcard fadein" style="margin-top:14px;padding:4px 0">
        ${types.map((t,i)=>`<div class="row" style="gap:12px;padding:9px 14px;${i?'border-top:1px solid var(--hair)':''}">
          <span style="width:32px;height:32px;border-radius:10px;background:var(--hair2);display:flex;align-items:center;justify-content:center">${ic(t[0],17,1.8,'var(--ink2)')}</span>
          <div style="flex:1"><div style="font-size:13.5px;font-weight:500">${t[1]}</div>
            <div style="font-size:11px;color:var(--ink3);margin-top:1px">${t[2]}</div></div>
          ${ic('check',13,2.2,'var(--ink3)')}</div>`).join('')}</div>`:''}
      <div style="font-size:12.5px;font-weight:600;color:var(--ink2);margin:16px 0 9px">添加可穿戴设备（可选）</div>
      <div class="row" style="gap:9px">
        ${wearables.map(([img,name])=>`<button class="wcard ${S.devices.has(name)?'on':''}" data-act="device" data-v="${name}"
           style="flex:1;padding:13px 4px;display:flex;flex-direction:column;align-items:center;gap:7px;border-radius:17px">
          <img src="Assets/${img}.png" style="width:38px;border-radius:10px">
          <span style="font-size:10.5px;color:${S.devices.has(name)?'var(--ink)':'var(--ink3)'};${S.devices.has(name)?'font-weight:600':''}">${name}</span></button>`).join('')}</div>
      <div class="row" style="gap:9px;align-items:flex-start;margin-top:16px">
        ${ic('info',13,1.8,'var(--ink3)','margin-top:2px')}
        <span class="zh-loose" style="font-size:11.5px;color:var(--ink3)">没有手表也可以，iPhone 自带的睡眠和步数也能读，只是解读会粗一些。</span></div>
    </div>
    <div class="foot">${cta(S.healthGranted?'导入最近 30 天':'连接 Apple Health','data-act="connectnext"')}</div>
  </div></div>`;
}

/* ---- 两次报告前的加载：同一个组件 ---- */
const LOADS={
  sync:{phase:'syncing', next:'frintro', kicker:'首读 · 读取 Apple Health', title:'正在读取你最近 30 天的数据',
    steps:['睡眠 · 30 晚','心率变异性 · 30 晚','心率 · 30 天','步数与运动 · 30 天','整理成你的首读报告'],
    note:'你的数据加密保存，只用来给你做解读。'},
  analyze:{phase:'analyzing', next:'t0intro', kicker:'阶段解读 · 唾液 + 手表', title:'正在把唾液和手表数据放在一起读',
    steps:['读取 5 管唾液','和你 30 天的手表数据放在一起','看压力激素一天里怎么变','看身体修复得怎么样','整理成你的阶段解读'],
    note:'唾液和手表数据要放在一起读，需要一点时间。'},
};
let loadTimer=null;
function vLoading(kind){
  const L=LOADS[kind], n=L.steps.length;
  return `<div class="view"><div class="fogscreen warm"></div>
  <div style="position:relative;display:flex;flex-direction:column;height:100%;padding:0 26px;color:#fff;
       padding-top:max(26px, env(safe-area-inset-top));padding-bottom:max(24px, env(safe-area-inset-bottom))">
    <div class="row" style="gap:8px"><span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
      <span style="font-size:10px;font-weight:700;letter-spacing:1.8px;color:rgba(255,255,255,.55)">${L.kicker}</span></div>
    <div style="flex:1 0 10px"></div>
    ${textSphere(170,50)}
    <div style="font-size:20px;font-weight:650;text-align:center;margin-top:18px">${L.title}</div>
    <div class="glass" style="border-radius:22px;padding:6px 18px;margin-top:22px">
      ${L.steps.map((t,i)=>`<div class="row ldrow" id="ld-row-${i}" style="gap:11px;padding:10px 0;${i?'border-top:1px solid rgba(255,255,255,.08)':''}">
        <span class="lddot" id="ld-dot-${i}"></span>
        <span id="ld-txt-${i}" style="font-size:13px;color:rgba(255,255,255,.35);transition:color .3s">${t}</span></div>`).join('')}</div>
    <div class="row" style="gap:12px;margin-top:20px">
      <div id="ld-bar" style="flex:1">${neonBar(0)}</div>
      <span id="ld-pct" class="num" style="font-size:11px;color:rgba(255,255,255,.5);width:32px;text-align:right">0%</span></div>
    <div style="flex:1 0 10px"></div>
    <div style="text-align:center;font-size:11px;color:rgba(255,255,255,.34)">${L.note}</div>
  </div></div>`;
}
function runLoading(kind,onDone){
  const L=LOADS[kind], n=L.steps.length;
  clearInterval(loadTimer); S.phase=L.phase; render();
  let p=0;
  const paint=()=>{
    for(let i=0;i<n;i++){
      const d=document.getElementById('ld-dot-'+i), t=document.getElementById('ld-txt-'+i); if(!d) return;
      const lo=i/n*100, hi=(i+1)/n*100, done=p>=hi, now=p>=lo&&!done;
      d.className='lddot'+(done?' done':now?' now':''); d.innerHTML=done?ic('check',9,2.6,'var(--ink)'):'';
      t.style.color=done?'#fff':now?'rgba(255,255,255,.85)':'rgba(255,255,255,.35)';
    }
    const b=document.getElementById('ld-bar'); if(b) b.innerHTML=neonBar(p);
    const c=document.getElementById('ld-pct'); if(c) c.textContent=p+'%';
  };
  paint();
  loadTimer=setInterval(()=>{
    if(S.phase!==L.phase){ clearInterval(loadTimer); return; }
    p=Math.min(100,p+1); paint();
    if(p>=100){ clearInterval(loadTimer);
      setTimeout(()=>{ if(S.phase===L.phase){ if(onDone) onDone(); S.phase=L.next; render(); } },520); }
  },42);
}
function beginSync(){ S.syncedItems=0; runLoading('sync'); }
function deliverReport(){
  S.points.forEach(p=>p.done=true);
  if(S.sheet) closeSheetNow();
  runLoading('analyze',()=>{ S.saliva=4; S.reopenT0=false; });
}

/* ---- 两次报告的总览首屏：同一个组件 ---- */
const INTROS={
  fr:{kicker:'首读报告 · 9月15日 – 10月14日', l1:'30 天的数据，', l2:'读出了 5 件事。',
      sub:'全部来自你的 Apple Health。一页一件，每页一张图。', to:'firstread',
      heads:[['睡眠','工作日总是睡不够'],['睡眠','一到周末，作息就往后漂'],['白天','白天越来越难放松下来'],
             ['夜里','夜里的恢复一周比一周差'],['运动','运动有规律，量还差一点']]},
  t0:{kicker:'阶段解读 · 30 天手表数据 + 10月16日唾液', l1:'手表数据加上唾液，', l2:'看清了你为什么累。',
      sub:'首读看到你最近睡不够、白天总绷着、夜里恢复变差。这次加上一天的唾液，找到了背后的原因。', to:'t0',
      heads:[['状态','你现在压力大，恢复跟不上'],['唾液','唾液里看到了两个问题'],['压力','压力激素白天退不下去'],
             ['恢复','身体一直在消耗，补得太慢'],['睡眠','入睡难，不怪生物钟']]},
};
function vIntro(k){
  const I=INTROS[k];
  return `<div class="view"><div class="fogscreen warm"></div>
  <div style="position:relative;display:flex;flex-direction:column;height:100%;padding:0 22px;color:#fff;
       padding-top:max(26px, env(safe-area-inset-top));padding-bottom:max(18px, env(safe-area-inset-bottom))">
    <div class="row" style="gap:8px"><span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
      <span style="font-size:10px;font-weight:700;letter-spacing:1.8px;color:rgba(255,255,255,.55)">${I.kicker}</span></div>
    <div style="flex:1 0 12px"></div>
    <div class="serif appearup" style="font-size:34px;font-weight:600;line-height:1.3">${I.l1}</div>
    <div class="serif appearup" style="font-size:34px;font-weight:500;line-height:1.35;color:var(--lime)">${I.l2}</div>
    <div class="zh-loose appearup" style="font-size:13px;color:rgba(255,255,255,.58);margin-top:10px">${I.sub}</div>
    <div style="flex:1 0 12px"></div>
    <div class="glass" style="border-radius:22px;padding:4px 16px">
      ${I.heads.map(([tag,t],i)=>`<div class="row appearup" style="gap:12px;padding:13px 0;${i?'border-top:1px solid rgba(255,255,255,.1)':''};animation-delay:${.15+i*.07}s">
        <span class="num" style="font-size:11px;color:rgba(255,255,255,.4);width:18px">0${i+1}</span>
        <span style="flex:1;font-size:14.5px;font-weight:600">${t}</span>
        <span style="font-size:10px;color:rgba(255,255,255,.45)">${tag}</span></div>`).join('')}</div>
    <div style="flex:1 0 12px"></div>
    ${cta('开始看',`data-act="phase" data-v="${I.to}"`)}
  </div></div>`;
}

/* ---- 5 About you (2 steps) ---- */
function ruler(valKey,val,min,max,unit){
  return `<div class="ruler"><div class="val">${val}<span>${unit}</span></div>
    <input type="range" min="${min}" max="${max}" value="${val}" data-ruler="${valKey}">
    <div class="ends"><span>${min}</span><span>${Math.round((min+max)/2)}</span><span>${max}</span></div></div>`;
}
function vProfile(){
  const step=S.profStep;
  const title=step===0?'先认识一下你':'你平时运动吗？';
  const sub=step===0?'年龄和性别不同，激素的正常范围也不一样。知道这些，我们才能按你的情况来看。'
                    :'运动多的人，身体需要的恢复时间不一样。我们也会照你的习惯来排计划。';
  let body='';
  if(step===0){
    body=`<div style="display:flex;flex-direction:column;gap:20px;padding-top:6px">
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">Aira 该怎么称呼你？</span></div>
        <input id="nick" value="${S.nickname.replace(/"/g,'&quot;')}" placeholder="Chloe"
          style="width:100%;background:#fff;border:1px solid var(--hair);border-radius:18px;padding:15px 17px;
                 font-size:21px;font-weight:600"></div>
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">年龄</span>
          <span style="font-size:11px;color:var(--ink3)">不同年龄，正常范围不一样</span></div>
        ${ruler('age',S.age,13,90,'岁')}</div>
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">出生性别</span>
          <span style="font-size:11px;color:var(--ink3)">男女的激素水平不太一样</span></div>
        <div class="seg">${['女','男','不想说'].map((o,i)=>
          `<button class="${S.sex===i?'on':''}" data-act="sex" data-v="${i}">${o}</button>`).join('')}</div>
        ${S.sex===2?`<div class="row" style="gap:8px;align-items:flex-start;margin-top:10px">${ic('info',12,1.9,'var(--ink3)','margin-top:3px')}
          <span class="zh-loose" style="font-size:11.5px;color:var(--ink3)">没关系，只是解读会稍微粗一点。</span></div>`:''}
      </div></div>`;
  } else {
    const freqs=[['不练','moon'],['1–2 次','run'],['3–4 次','run'],['5 次以上','run']];
    body=`<div style="display:flex;flex-direction:column;gap:16px;padding-top:10px">
      <div style="font-size:13px;font-weight:600">每周运动几次？</div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:9px">
        ${freqs.map((f,i)=>`<button class="wcard" data-act="band" data-v="${i}"
          style="padding:17px 4px;border-radius:17px;display:flex;flex-direction:column;align-items:center;gap:5px;
          ${S.sessionBand===i?'background:var(--ink);color:#fff;border-color:var(--ink)':''}">
          ${ic(f[1],18,1.9,S.sessionBand===i?'#fff':'var(--ink2)')}
          <span style="font-size:14px;${S.sessionBand===i?'font-weight:600':'font-weight:500'}">${f[0]}</span></button>`).join('')}</div>
      ${S.sessionBand>0?`<div class="fadein"><div style="font-size:13px;font-weight:600;margin:8px 0 10px">坚持多久了？</div>
        ${ruler('years',S.years,0,30,'年')}</div>`:''}
    </div>`;
  }
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(0,2, step===0?'data-act="phase" data-v="welcome"':'data-act="profstep" data-v="0"')}
    <h2>${title}</h2><div class="sub">${sub}</div>
    <div class="body">${body}</div>
    <div class="foot">${cta('继续', step===0?'data-act="profstep" data-v="1"':'data-act="finishonb"')}</div>
  </div></div>`;
}

/* ---- 唾液检测：指引 → 采样日 → 寄出等待（onboarding 主线） ---- */
function salTop(k){
  return `<div class="row" style="gap:8px;padding-top:max(20px, env(safe-area-inset-top))">
    <span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
    <span style="font-size:10px;font-weight:700;letter-spacing:1.8px;color:var(--ink3)">${k}</span></div>`;
}
function fiveTubes(w=312,h=118){
  const X=t=>22+(t-6)/18*(w-44), Y=v=>16+(1-v/8)*(h-46);
  const curve=[[6,4.4],[6.75,5.6],[7.25,7.2],[8.5,6.2],[11.5,3.9],[15,2.3],[19,1.2],[23.5,.5]];
  const tubes=[[6.75,5.6,'醒来'],[7.25,7.2,'+30 分'],[11.5,3.9,'午饭前'],[15,2.3,'下午'],[23.5,.5,'睡前']];
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  [6,12,18,24].forEach(t=>{ s+=`<text x="${X(t)}" y="${h-4}" fill="rgba(255,255,255,.34)" font-size="9" text-anchor="${t===6?'start':t===24?'end':'middle'}">${String(t%24).padStart(2,'0')}:00</text>`; });
  s+=`<path d="${smoothPath(curve.map(([t,v])=>[X(t),Y(v)]))}" stroke="rgba(255,255,255,.38)" stroke-width="1.6" fill="none" stroke-dasharray="3 4"/>`;
  tubes.forEach(([t,v,l],i)=>{
    s+=`<circle cx="${X(t)}" cy="${Y(v)}" r="5.5" fill="var(--lime)" stroke="#151514" stroke-width="2"/>`;
    s+=`<text x="${X(t)+(i===0?-6:i===1?8:0)}" y="${Y(v)+(i===4?-11:i<2?-10:18)}" fill="#fff" font-size="10" font-weight="600" text-anchor="${i===0?'end':i===1?'start':'middle'}">${l}</text>`;
  });
  return s+'</svg>';
}
function vSaliva(){
  const avoid=['前一天起，先别吃生物素（维生素 B7）','每管前 30 分钟不吃东西、不喝咖啡','每管前 10 分钟不刷牙','醒来后先别运动，第一管在床上取'];
  return `<div class="view" style="background:var(--page)">
  <div class="scroll" style="padding:0 20px 20px">
    ${salTop('唾液检测')}
    <div style="font-size:26px;font-weight:650;line-height:1.35;margin-top:12px">原因，藏在一天的唾液里</div>
    <div class="zh-loose" style="font-size:13.5px;color:var(--ink2);margin-top:8px">手表能看到你累，看不到为什么。压力激素有没有按时退下去、身体修复得怎么样、生物钟准不准，要从唾液里看。</div>
    <div class="fog cool" style="margin-top:16px"><div class="bg"></div><div class="pad">
      ${cardHead('drop','一天五管','在家完成 · 寄回实验室','每管 2 分钟','sky')}
      <div style="margin-top:12px">${fiveTubes()}</div>
      <div class="zh-loose" style="font-size:12px;color:var(--onD2);margin-top:8px">压力激素正常是早上高、晚上低。五个时间点连起来，就能看出你的一天是怎么变的。</div></div></div>
    <div class="fog flat" style="margin-top:12px"><div class="bg"></div><div class="pad">
      ${cardHead('info','采样当天避开','都会让结果不准')}
      <div style="display:flex;flex-direction:column;gap:11px;margin-top:12px">
      ${avoid.map(t=>`<div class="row" style="gap:10px;align-items:flex-start">
        <span style="width:18px;height:18px;border-radius:50%;background:rgba(255,138,91,.16);display:flex;align-items:center;justify-content:center;flex:none;margin-top:2px">${ic('close',9,2.4,'var(--coral)')}</span>
        <span class="zh-loose" style="font-size:13px;color:var(--onD2)">${t}</span></div>`).join('')}</div></div></div>
  </div>
  <div style="padding:10px 20px max(20px, env(safe-area-inset-bottom))">${cta('安排在明天','data-act="schedule"')}</div></div>`;
}
function vCollect(){
  return `<div class="view" style="background:var(--page)">
  <div class="scroll" style="padding:0 20px 20px">
    ${salTop('采样日 · 10月16日')}
    <div style="font-size:26px;font-weight:650;line-height:1.35;margin-top:12px">明天采五管</div>
    <div class="zh-loose" style="font-size:13.5px;color:var(--ink2);margin-top:8px">五管的步骤都一样。先跟着走一遍，到点照做就行，每个时间点前后 15 分钟内都有效。</div>
    <div style="margin-top:16px;border-top:1px solid var(--hair)">
    ${S.points.map(p=>`<div class="row" style="gap:12px;padding:13px 2px;border-bottom:1px solid var(--hair)">
      <span class="num" style="font-size:13px;width:44px;flex:none">${p.when}</span>
      <span style="flex:1"><span style="display:block;font-size:14px;font-weight:600">${p.name}</span>
        <span style="display:block;font-size:11.5px;color:var(--ink3);margin-top:2px">${p.hint}</span></span></div>`).join('')}</div>
  </div>
  <div style="padding:10px 20px max(20px, env(safe-area-inset-bottom))">${cta('看一遍采样步骤','data-act="guide"')}</div></div>`;
}
function vWaiting(){
  const steps=[['五管全部采好',1],['已寄出 · 10月16日',1],['实验室处理中',0],['和 30 天手表数据一起解读',0]];
  return `<div class="view"><div class="fogscreen"></div>
  <div style="position:relative;display:flex;flex-direction:column;justify-content:center;height:100%;padding:0 26px;color:#fff">
    ${textSphere(160,46)}
    <div style="font-size:22px;font-weight:600;text-align:center;margin-top:20px">样本在路上了</div>
    <div class="zh-loose" style="font-size:13px;color:rgba(255,255,255,.6);text-align:center;margin-top:8px">结果通常 5–7 个工作日。出来后，Aira 会把它和这 30 天的手表数据放在一起读。</div>
    <div class="glass" style="border-radius:22px;padding:18px;margin-top:22px;display:flex;flex-direction:column;gap:12px">
      ${steps.map(([t,d])=>`<div class="row" style="gap:10px">
        <span style="width:16px;height:16px;border-radius:50%;flex:none;display:flex;align-items:center;justify-content:center;
          ${d?'background:var(--lime)':'border:1.4px solid rgba(255,255,255,.22)'}">${d?ic('check',9,2.6,'var(--ink)'):''}</span>
        <span style="font-size:13px;color:${d?'#fff':'rgba(255,255,255,.4)'}">${t}</span></div>`).join('')}</div>
    <div style="margin-top:24px">${cta('演示：报告已出','data-act="fastforward"')}</div>
  </div></div>`;
}

/* ---- Main shell (Home / Aira / Plan) ---- */
function vMain(){
  let inner='';
  if(S.tab===0) inner=vHome();
  else if(S.tab===1) inner=vAgent();
  else inner=vPlan();
  return `<div class="view" style="background:var(--page)">
    ${S.tab===1?'<div class="fogscreen"></div>':''}
    <div style="position:relative;flex:1;display:flex;flex-direction:column;min-height:0">${inner}</div>
    ${tabbar()}
  </div>`;
}
function tabbar(){
  return `<div class="tabbar-wrap"><div class="tabbar">
    <button class="${S.tab===0?'active':''}" data-act="tab" data-v="0">${ic('home',21,S.tab===0?2.1:1.7)}<span>首页</span></button>
    <button class="aira ${S.tab===1?'active':''}" data-act="tab" data-v="1">
      <span class="orb">${ic('spark',22,2,S.tab===1?'var(--ink)':'#fff')}
        ${S.unread>0&&S.tab!==1?'<span class="unread"></span>':''}</span></button>
    <button class="${S.tab===2?'active':''}" data-act="tab" data-v="2">${ic('plan',21,S.tab===2?2.1:1.7)}<span>计划</span></button>
  </div></div>`;
}

/* ---- Home tab：首读入口 · T0 入口 · 状态自查 ---- */
function scoreRing(score,color,size=96){
  const C=size/2, r=C-3, N=48, f=v=>v.toFixed(1);
  let s=`<svg width="${size}" height="${size}" viewBox="0 0 ${size} ${size}" style="display:block;margin:0 auto">`;
  for(let i=0;i<N;i++){
    const a=(-90+i*360/N)*Math.PI/180, on=i<Math.round(N*score/100);
    s+=`<line x1="${f(C+Math.cos(a)*(r-size*.1))}" y1="${f(C+Math.sin(a)*(r-size*.1))}" x2="${f(C+Math.cos(a)*r)}" y2="${f(C+Math.sin(a)*r)}"
      stroke="${on?color:'rgba(255,255,255,.13)'}" stroke-width="${(size/36).toFixed(1)}" stroke-linecap="round"/>`;
  }
  return s+`<text x="${C}" y="${C+size*.1}" text-anchor="middle" font-size="${Math.round(size*.28)}" font-weight="650" fill="#fff">${score}</text></svg>`;
}
function reportEntry(act,fog,icon,title,sub,chip,body){
  return `<button data-act="${act}" style="display:block;width:100%;text-align:left">
    <div class="fog ${fog}"><div class="bg"></div><div class="pad" style="padding:18px">
      ${cardHead(icon,title,sub,chip?chip[0]:null,chip?chip[1]:'good')}
      ${body}
      <div class="row" style="gap:6px;margin-top:14px;color:var(--lime);font-size:12.5px;font-weight:600">
        看报告 ${ic('arrowRight',12,2,'var(--lime)')}</div></div></div></button>`;
}
function vHome(){
  const fr=INTROS.fr, t0=INTROS.t0;
  return `<div class="scroll" style="padding:0 16px 110px;padding-top:max(14px, env(safe-area-inset-top))">
    <div class="row" style="padding:0 4px;gap:12px">
      <div style="flex:1"><div style="font-size:12.5px;color:var(--ink3)">${TODAY.label}</div>
        <div style="font-size:21px;font-weight:600;margin-top:3px">早上好，${nick()}</div></div>
      <img src="Assets/avatar.jpg" style="width:48px;height:48px;border-radius:50%;object-fit:cover;
           border:2px solid rgba(255,255,255,.9);box-shadow:0 3px 8px rgba(0,0,0,.25)"></div>
    <div style="padding:0 4px;margin-top:22px">${sectionLabel('你的报告')}</div>
    <div style="display:flex;flex-direction:column;gap:12px;margin-top:10px">
      ${reportEntry('openfr','cool','moon','首读报告','Apple Health · 9月15日 – 10月14日',['5 件事','sky'],
        `<div style="font-size:17px;font-weight:650;line-height:1.45;margin-top:12px">30 天的数据，读出了 5 件事</div>
         <div style="margin-top:8px">${fr.heads.map(([tag,t],i)=>`<div class="row" style="gap:10px;padding:7px 0;${i?'border-top:1px solid var(--hairD)':''}">
           <span class="num" style="font-size:10px;color:var(--onD3);width:16px">0${i+1}</span>
           <span style="flex:1;font-size:13px;color:rgba(255,255,255,.88)">${t}</span>
           <span style="font-size:9.5px;color:var(--onD3)">${tag}</span></div>`).join('')}</div>`)}
      ${reportEntry('opent0','warm','drop','阶段解读','唾液 10月16日 + 手表 30 天',['高负荷','warn'],
        `<div class="row" style="gap:16px;align-items:center;margin-top:14px">
           <div style="text-align:center">${scoreRing(72,'#FFB85C',78)}<div style="font-size:10.5px;color:var(--onD2);margin-top:4px">压力负荷</div></div>
           <div style="text-align:center">${scoreRing(44,'#DCF55A',78)}<div style="font-size:10.5px;color:var(--onD2);margin-top:4px">恢复状态</div></div>
           <div style="flex:1;font-size:13.5px;font-weight:600;line-height:1.55">压力大，<br>恢复跟不上</div></div>
         <div style="margin-top:10px">${t0.heads.slice(1,4).map(([tag,t],i)=>`<div class="row" style="gap:10px;padding:7px 0;border-top:1px solid var(--hairD)">
           <span class="num" style="font-size:10px;color:var(--onD3);width:16px">0${i+2}</span>
           <span style="flex:1;font-size:13px;color:rgba(255,255,255,.88)">${t}</span>
           <span style="font-size:9.5px;color:var(--onD3)">${tag}</span></div>`).join('')}</div>
         <div style="font-size:11px;color:var(--onD3);margin-top:8px">${TODAY.retest}复测 · 还有 ${TODAY.daysLeft} 天</div>`)}
    </div>
    <div style="padding:0 4px;margin-top:24px">${sectionLabel('状态自查')}</div>
    <div style="margin-top:10px;padding:16px;border-radius:22px;background:#fff;border:1px solid var(--hair)">
      <div class="row">
        <div style="flex:1"><div style="font-size:15px;font-weight:600">${S.loggedToday?`今天：${faceNames[S.feel]}`:'今天感觉怎么样？'}</div>
          <div style="font-size:11px;color:var(--ink3);margin-top:2px">${S.loggedToday?'已记录 · 可以随时改':'手表测不了感受，一天记一次，Aira 会拿它对照你的数据'}</div></div>
        <button data-act="sheet" data-v="checkin" style="display:flex;align-items:center;gap:6px;padding:8px 12px;flex:none;
          border-radius:99px;background:var(--ink);color:#fff;font-size:12px;font-weight:600">
          ${ic(S.loggedToday?'refresh':'plus',12,2.2,'#fff')} ${S.loggedToday?'修改':'记录'}</button></div>
      <div style="margin-top:6px">${selfTrend()}</div></div>
  </div>`;
}

/* ---- Agent tab ---- */
function vAgent(){
  const asks=['「高负荷」是什么意思？','为什么先从睡前开始？','白天紧绷怎么缓解？','什么时候复测？','运动要不要加量？']
    .filter(c=>!S.sent.includes(c));
  return `<div style="display:flex;flex-direction:column;height:100%;color:#fff">
    <div style="text-align:center;padding-top:max(14px, env(safe-area-inset-top));position:relative;flex:none">
      <div style="width:46px;height:46px;border-radius:50%;background:rgba(255,255,255,.10);
        border:1px solid rgba(255,255,255,.18);margin:6px auto 0;display:flex;align-items:center;justify-content:center;position:relative">
        <span style="position:absolute;top:-4px;right:-4px;width:16px;height:16px;border-radius:50%;background:var(--lime);filter:blur(7px)"></span>
        ${ic('spark',20,1.9,'var(--lime)')}</div>
      <div style="font-size:13.5px;font-weight:600;margin-top:5px">Aira</div>
      <div style="font-size:10.5px;color:rgba(255,255,255,.42);margin-top:2px">第 1 周 / 4 · ${TODAY.retest}复测</div>
      <button data-act="opent0" aria-label="T0 报告" style="position:absolute;right:16px;top:max(22px, env(safe-area-inset-top));
        width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.10);display:flex;align-items:center;justify-content:center">
        ${ic('drop',16,1.9,'rgba(255,255,255,.8)')}</button></div>
    <div style="display:flex;gap:7px;overflow-x:auto;scrollbar-width:none;padding:10px 16px;flex:none">
      ${ctxChip('pulse','压力负荷','72',true)}
      ${ctxChip('recover','恢复状态','44',true)}
      ${ctxChip('moon','入睡','38 分',true)}
      ${ctxChip('clock','白天紧绷','近 2 小时',true)}
    </div>
    <div id="threadscroll" class="scroll" style="padding:4px 14px 10px">${buildThread()}</div>
    <div style="flex:none;padding:8px 0 90px">
      <div style="display:flex;gap:7px;overflow-x:auto;scrollbar-width:none;padding:0 16px 8px">
        <button class="replychip" data-act="opent0" style="background:var(--lime);color:var(--ink);font-weight:600;flex:none">
          ${ic('drop',11,2.2,'var(--ink)')} 看阶段解读</button>
        ${asks.map(c=>`<button class="replychip glass" data-act="send" data-v="${c}" style="flex:none;font-size:12.5px">${c}</button>`).join('')}
      </div>
      <div class="row" style="gap:10px;padding:0 16px">
        <button data-act="sheet" data-v="checkin" style="width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.10);
          display:flex;align-items:center;justify-content:center;flex:none">${ic('plus',17,2,'rgba(255,255,255,.75)')}</button>
        <div class="row" style="flex:1;gap:8px;padding:5px 5px 5px 15px;border-radius:99px;background:rgba(255,255,255,.09);
             border:1px solid rgba(255,255,255,.13)">
          <input id="composer" placeholder="问问 Aira" style="flex:1;color:#fff;font-size:15px;min-width:0">
          <button data-act="composer" style="width:28px;height:28px;border-radius:50%;background:rgba(255,255,255,.10);
            display:flex;align-items:center;justify-content:center;flex:none">${ic('arrowUp',14,2.4,'rgba(255,255,255,.3)')}</button>
        </div></div></div>
  </div>`;
}
function ctxChip(icon,label,value,warn){
  return `<span class="ctxchip glass">${ic(icon,12,2,warn?'var(--amber)':'var(--lime)')}
    <span>${label}</span><b>${value}</b></span>`;
}
function bub(t,lead=false,grouped=false,delay=null){
  return `<div class="bubble glass ${lead?'lead':''} ${delay!=null?'fresh':''}" style="border-radius:${grouped?'19px 19px 19px 5px':'19px'};margin-top:${grouped?'3px':'14px'}${delay!=null?';animation-delay:'+delay+'s':''}">${t}</div>`;
}
function userBub(t,fresh=false){ return `<div class="bubble user ${fresh?'fresh':''}" style="margin-top:14px">${t}</div>`; }
/* 开场摘要在上，用户问答按发送顺序依次追加在下 */
function buildThread(){
  let out=`<div class="stagemark" style="margin-top:8px">10月22日 · 阶段解读</div>`;
  out+=bub('你的阶段解读出来了。');
  out+=bub('简单说：你最近压力很大，身体却一直没缓过来。',true,true);
  out+=`<button data-act="opent0" style="display:block;width:calc(100% - 28px);margin:10px 28px 0 0;text-align:left">
    <div class="glass" style="border-radius:22px;padding:16px;color:#fff">
      <div class="cardhead"><div class="ibadge">${ic('drop',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">阶段解读</div><div class="b">唾液 10/16 + 手表 30 天</div></div>${chipEl('高负荷','warn')}</div>
      <div class="row" style="justify-content:space-around;margin-top:12px">
        ${[[72,'#FFB85C','压力负荷'],[44,'#DCF55A','恢复状态']].map(([v,c,n])=>`<div style="text-align:center">${scoreRing(v,c,74)}
          <div style="font-size:11px;color:rgba(255,255,255,.6);margin-top:4px">${n}</div></div>`).join('')}</div>
      <div class="row" style="justify-content:flex-end;gap:5px;margin-top:10px;font-size:12px;font-weight:600;color:var(--lime)">
        看完整报告 ${ic('arrowRight',11,2.2,'var(--lime)')}</div></div></button>`;
  out+=bub('最该先改的是睡前这一个小时。你的压力激素到睡前还没退下去，所以躺下半小时都睡不着。');
  out+=bub('接下来四周的计划我排好了，挑一两件先做就行。',false,true);
  out+=`<button data-act="tab" data-v="2" class="row" style="gap:7px;margin:10px 0 0;padding:11px 16px;border-radius:99px;
    background:var(--lime);color:var(--ink);font-size:12.5px;font-weight:600">去计划看看 ${ic('arrowRight',12,2.2,'var(--ink)')}</button>`;
  if(S.sent.length||S.typing) out+=`<div class="stagemark" style="margin-top:20px">今天</div>`;
  S.sent.forEach((s,i)=>{ out+=exchange(s, i===S.sent.length-1 && S.fresh); });
  if(S.typing) out+=userBub(S.typing,true)+`<div class="bubble glass typing" style="margin-top:14px"><i></i><i></i><i></i></div>`;
  return out;
}
const AIRA_QA={
  '「高负荷」是什么意思？':['就是压力一直很大，身体又没来得及缓过来。','这种时候最不该做的，就是继续给自己加码。'],
  '为什么先从睡前开始？':['因为它最容易见效。','睡前压力退下去了，你会睡得更快，欠的觉也补得回来，一件事两头都好。'],
  '白天紧绷怎么缓解？':['你白天最紧张的是下午 2 点到 5 点。那会儿起身走 15 分钟，比熬到下班再运动更管用。','我已经把它放进推荐活动了。'],
  '什么时候复测？':[`${TODAY.retest}，和这次一样的五个时间点。`,'到时候同样的图再画一次，看你有没有从「高负荷」回到「负荷可控」。'],
  '运动要不要加量？':['先别加。你的运动本来就规律，量也只差一点。','现在身体在「高负荷」，加强度只会让恢复更吃紧。等复测回到「负荷可控」再说。'],
};
function airaReply(s){
  if(AIRA_QA[s]) return AIRA_QA[s];
  if(/睡|醒|失眠|困/.test(s)) return ['你这一周少睡了 6 个小时，想多睡是对的。','可以先试试 00:15 前躺下，再配合 23:00 后放下工作和手机，入睡会快一些。'];
  if(/运动|练|跑|健身|走路/.test(s)) return AIRA_QA['运动要不要加量？'];
  if(/压力|紧|焦虑|累|烦/.test(s)) return ['这个月白天紧绷越来越长，修复类激素也偏低——累是真实的，不是你想多了。','先从晚上早点放下工作、下午起来走走开始，这两件最容易见效。'];
  if(/复测|唾液|检测|报告/.test(s)) return AIRA_QA['什么时候复测？'];
  if(/计划|目标|怎么做|开始/.test(s)) return ['计划主要管三件事：睡得着、白天松一点、把欠的觉补回来。从你最愿意做的那条开始就行。'];
  return ['我在。照你现在的情况，最值得先做的是晚上 23:00 后放下工作和手机。想聊聊具体怎么做吗？'];
}
function exchange(s,fresh=false){
  let out=userBub(s);
  airaReply(s).forEach((r,i)=>{ out+=bub(r,false,i>0,fresh?i*.35:null); });
  return out;
}
function send(s){
  if(S.sent.includes(s)||S.typing) return;
  S.typing=s; S.fresh=false; S.unread=0; render();
  setTimeout(()=>{ S.typing=null; S.sent.push(s); S.fresh=true; render(); S.fresh=false; },1100);
}

/* ---- Plan tab：本轮目标 → 推荐（滑卡） → 本周 ---- */
function dayRing(frac,sel,has){
  const r=17, c=2*Math.PI*r;
  return `<svg width="40" height="40" viewBox="0 0 40 40" style="position:absolute;inset:0">
    <circle cx="20" cy="20" r="${r}" fill="none" stroke="${sel?'rgba(255,255,255,.18)':'var(--hair)'}" stroke-width="2.4"/>
    ${has&&frac>0?`<circle cx="20" cy="20" r="${r}" fill="none" stroke="var(--lime)" stroke-width="2.4" stroke-linecap="round"
      stroke-dasharray="${(c*frac).toFixed(1)} ${c.toFixed(1)}" transform="rotate(-90 20 20)"/>`:''}</svg>`;
}
function vPlan(){
  const items=dayItems(S.plan.day), D=WEEK[S.plan.day];
  const wk=WEEK.map((_,i)=>dayItems(i)), tot=wk.reduce((s,a)=>s+a.length,0);
  const dn=wk.reduce((s,a,i)=>s+a.filter(x=>S.plan.done.has(i+'-'+x.key)).length,0);
  const anim=S._dayAnim; S._dayAnim=false;
  const met=[['入睡要多久','38','20','分钟'],['白天紧绷','120','80','分钟'],['睡眠债','6','2','小时']];
  return `<div class="scroll" style="padding:0 20px 110px;padding-top:max(14px, env(safe-area-inset-top))">
    <div class="row" style="align-items:flex-start;padding-top:14px">
      <div style="flex:1"><div style="font-size:12.5px;color:var(--ink3)">第 1 周 / 4 · ${TODAY.retest}复测</div>
        <div style="font-size:23px;font-weight:600;margin-top:3px">你的计划</div></div>
      <img src="Assets/avatar.jpg" style="width:40px;height:40px;border-radius:50%;object-fit:cover;border:2px solid #fff;box-shadow:0 3px 8px rgba(0,0,0,.2)"></div>

    <div class="fog cool" style="margin-top:15px"><div class="bg"></div><div class="pad">
      ${cardHead('spark','这四周的目标','来自阶段解读 · 四周后再测','高负荷','warn')}
      <div style="font-size:17px;font-weight:600;line-height:1.5;margin-top:12px">先从睡好觉开始</div>
      <div class="zh-loose" style="font-size:13px;color:var(--onD2);margin-top:6px">晚上早点放下工作，躺下能更快睡着，欠的觉也能慢慢补回来。睡好了，白天自然轻松些。</div>
      <div class="row" style="margin-top:14px;border-top:1px solid var(--hairD)">
        ${met.map(([k,a,b,u],i)=>`<div style="flex:1;padding:11px 0 0 ${i?'12px':'0'};${i?'border-left:1px solid var(--hairD)':''}">
          <div style="font-size:10px;color:var(--onD3)">${k}</div>
          <div class="num" style="font-size:15px;margin-top:4px"><span style="color:#FFD9A0">${a}</span><span style="color:var(--onD3);font-size:11px"> → </span><span style="color:#E7FA9A">${b}</span><span style="font-size:10px;color:var(--onD3)"> ${u}</span></div></div>`).join('')}</div>
    </div></div>

    <div class="row" style="margin-top:24px">${sectionLabel('推荐给你 · 按影响分排序')}
      ${deck().length?`<span style="margin-left:auto;font-size:10.5px;font-weight:600;color:var(--ink3)">还有 ${deck().length} 条</span>`:''}</div>
    <div style="font-size:11.5px;color:var(--ink3);margin-top:4px;line-height:1.55">影响分满分 10。分越高，这件事对你越有用：它对准你最需要改善的地方，有数据支持，也容易做到。</div>
    <div style="margin-top:10px">${deckHTML()}</div>

    <div class="row" style="margin-top:26px">${sectionLabel('本周')}
      ${tot?`<span style="margin-left:auto;font-size:11px;color:var(--ink3)">本周完成 <b class="num" style="color:var(--ink)">${dn}</b> / ${tot}</span>`:''}</div>
    <div class="wkcard">
      <div class="wkstrip">
      ${WEEK.map((d,i)=>{ const its=wk[i], n=its.filter(x=>S.plan.done.has(i+'-'+x.key)).length, sel=S.plan.day===i, full=its.length&&n===its.length;
        return `<button class="wkday ${sel?'sel':''} ${full?'full':''}" data-act="pday" data-v="${i}">
          <span class="w">${i===0?'今天':d.w.replace('周','')}</span>
          <span class="c">${dayRing(its.length?n/its.length:0,sel,its.length)}<b>${full&&!sel?ic('check',14,2.8,'var(--ink)'):d.date}</b></span></button>`;}).join('')}
      </div>
      ${(()=>{ const n=items.filter(x=>S.plan.done.has(S.plan.day+'-'+x.key)).length, full=items.length&&n===items.length;
        return `<div class="dayhead ${full?'full':''}">
          <div class="row"><b>${full?(S.plan.day===0?'今天':D.w)+'全部完成':(S.plan.day===0?'今天':D.w)+' · 10月'+D.date+'日'}</b>
            ${items.length?`<span class="num">${n} / ${items.length}</span>`:''}</div>
</div>`; })()}
      <div class="tklist ${anim?'fadein':''}">
      ${items.length?items.map(x=>{ const key=S.plan.day+'-'+x.key, d=S.plan.done.has(key);
        return `<button class="tk ${d?'done':''}" data-act="pdone" data-v="${key}">
          <span class="ck">${ic('check',12,2.8,'var(--ink)')}</span>
          <span class="tx"><b>${x.title}</b><small><span class="num">${x.time}</span> · ${x.tag}</small></span>
          <span class="ico" style="background:${x.col}2e">${ic(x.icon,16,1.8,'var(--ink)')}</span></button>`;}).join('')
      :`<div class="tlempty">${S.plan.acc.size?'这天没有安排，歇一歇。':'右滑上面的推荐，这里会排好每天做什么。'}</div>`}
      </div>
    </div>
    <button data-act="tab" data-v="1" class="row" style="gap:9px;width:100%;margin-top:22px;padding:15px 16px;
      border-radius:18px;background:#fff;border:1px solid var(--hair);text-align:left">
      ${ic('ask',15,2,'var(--ink)')}<span style="flex:1;font-size:14px;font-weight:500">和 Aira 聊聊这份计划</span>
      ${ic('chevron',12,2,'var(--ink3)')}</button>
  </div>`;
}
function impactMeter(r){
  return `<div style="display:flex;align-items:baseline;gap:2px"><span class="num" style="font-size:24px;color:${r.col}">${r.impact}</span><span style="font-size:10px;color:var(--onD3)">/10</span></div>
    <div style="font-size:9px;font-weight:700;letter-spacing:1px;color:var(--onD3);margin-top:1px">影响分</div>`; }
const deck=()=>ACTS.filter(a=>!S.plan.acc.has(a.id)&&!S.plan.skip.has(a.id)).sort((x,y)=>y.impact-x.impact);
function recCard(r,open){
  const t=targetOf(r.target);
  return `<div class="fog ${r.saliva?'cool':'flat'}" style="border-radius:22px"><div class="bg"></div><div class="pad" style="padding:18px">
    <div class="row" style="gap:12px;align-items:flex-start">
      <div style="width:54px;flex:none">${impactMeter(r)}</div>
      <div style="flex:1;min-width:0"><div class="row" style="gap:6px">
          <span style="font-size:9.5px;font-weight:700;letter-spacing:1px;padding:3px 8px;border-radius:99px;background:${r.col};color:var(--ink)">${r.tag}</span>
          ${r.saliva?`<span class="row" style="gap:3px">${ic('drop',9,2.2,'var(--lime)')}<span style="font-size:8.5px;font-weight:700;letter-spacing:1px;color:var(--lime)">唾液证据</span></span>`:''}</div>
        <div style="font-size:17px;font-weight:600;line-height:1.45;margin-top:6px">${r.title}</div>
        <div style="font-size:11px;color:var(--onD3);margin-top:2px">${r.when} · 为了「${t.title}」</div></div></div>
    <div class="row" style="gap:8px;align-items:flex-start;margin-top:12px">
      ${ic('spark',12,2,'var(--lime)','margin-top:3px')}
      <span class="zh-loose" style="font-size:12.5px;color:var(--onD2);${open?'':'display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden'}">${r.because}</span></div>
    ${open?`<div class="fadein" style="margin-top:12px"><div class="hair-d"></div>
      <div style="font-size:9px;font-weight:700;letter-spacing:2px;color:var(--onD3);margin-top:10px">为什么是 ${r.impact} 分</div>
      <div style="margin-top:6px">${r.why3.map(t=>`<div class="row" style="gap:7px;padding:3px 0;font-size:12px;color:rgba(255,255,255,.8)">${ic('check',10,2.4,r.col)}${t}</div>`).join('')}</div>
      <div style="font-size:9px;font-weight:700;letter-spacing:2px;color:var(--onD3);margin-top:12px">依据</div>
      <div class="row" style="gap:6px;flex-wrap:wrap;margin-top:8px">${r.evidence.map(e=>`<span class="evchip"><span class="d"></span>${e}</span>`).join('')}</div>
      <div class="row" style="gap:7px;margin-top:10px">${ic('clock',11,2,'var(--onD3)')}<span style="font-size:11px;color:var(--onD2)">${r.onset}</span></div></div>`:''}
    <div class="row" style="margin-top:10px">
      <span style="font-size:10.5px;color:var(--onD3);flex:1">${r.how}</span>
      <button data-act="deckopen" class="row" style="gap:4px;color:var(--lime);font-size:11px;font-weight:600;padding:4px 0 4px 10px">
        ${open?'收起':'为什么'} ${ic('chevron',8,2.4,'var(--lime)',`transform:rotate(${open?'-90deg':'90deg'})`)}</button></div>
  </div></div>`;
}
function deckHTML(){
  const d=deck();
  if(!d.length){
    return `<div style="text-align:center;padding:24px;border-radius:22px;background:#fff;border:1px solid var(--hair)">
      <span style="width:44px;height:44px;border-radius:50%;background:rgba(220,245,90,.5);display:inline-flex;align-items:center;justify-content:center">${ic('check',18,2.4,'var(--ink)')}</span>
      <div style="font-size:14.5px;font-weight:600;margin-top:10px">推荐都看完了</div>
      <div style="font-size:11.5px;color:var(--ink3);margin-top:3px">${S.plan.acc.size} 条已加入${S.plan.skip.size?` · ${S.plan.skip.size} 条跳过`:''}</div>
      ${S.plan.skip.size?`<button data-act="restoreskipped" style="margin-top:10px;font-size:12px;font-weight:600;padding:8px 14px;border-radius:99px;background:#fff;border:1px solid var(--hair)">回看跳过的</button>`:''}</div>`;
  }
  const under=d.slice(1,3).map((r,i)=>`<div style="position:absolute;inset:0;transform:rotate(${i===0?2.4:-2}deg) translate(${i===0?7:-8}px, ${(i+1)*9}px);
      opacity:${1-(i+1)*0.18};z-index:${2-i};pointer-events:none">${recCard(r,false)}</div>`).join('');
  return `<div class="deckwrap" style="padding-bottom:${Math.min(d.length-1,2)*10+4}px">
    <div style="position:relative">${under}
      <div id="topcard" class="deckcard" style="position:relative;z-index:3">${recCard(d[0],S.deckOpen)}
        <div id="swipehints" style="position:absolute;inset:0;display:flex;align-items:center;justify-content:space-between;padding:0 12px;pointer-events:none;opacity:0;transition:opacity .15s">
          <span style="padding:7px 10px;border-radius:99px;background:rgba(0,0,0,.5);color:#fff;font-size:11px;font-weight:700">‹ 跳过</span>
          <span style="padding:7px 10px;border-radius:99px;background:var(--lime);color:var(--ink);font-size:11px;font-weight:700">加入计划 ›</span></div></div></div>
    <div class="deck-dots">${[...ACTS].sort((x,y)=>y.impact-x.impact).map(r=>`<i class="${S.plan.acc.has(r.id)?'acc':S.plan.skip.has(r.id)?'skp':''}"></i>`).join('')}</div>
    <div style="text-align:center;font-size:10px;color:var(--ink3);margin-top:8px">右滑加入 · 左滑跳过 · 点「为什么」看依据</div></div>`;
}
function flyOff(card,dir,cb){
  card.style.transition='transform .28s ease-out, opacity .28s';
  card.style.transform=`translateX(${dir*480}px) rotate(${dir*18}deg)`;
  card.style.opacity='0';
  setTimeout(cb,250);
}
function deckDecide(dir){
  const d=deck()[0], card=document.getElementById('topcard'); if(!d) return;
  const done=()=>{ (dir>0?S.plan.acc:S.plan.skip).add(d.id); S.deckOpen=false; render(); toast(dir>0?'已加入本周计划':'已跳过'); };
  card?flyOff(card,dir,done):done();
}

/* ================= Sheets ================= */
function openSheet(kind,arg=null){
  S.sheet=kind; S.sheetArg=arg;
  $sheet.innerHTML=sheetHTML(kind);
  $veil.classList.add('open');
  requestAnimationFrame(()=>requestAnimationFrame(()=>$sheet.classList.add('open')));
}
function closeSheet(cb){
  $sheet.classList.remove('open'); $veil.classList.remove('open');
  const k=S.sheet; S.sheet=null;
  setTimeout(()=>{ $sheet.innerHTML=''; if(cb)cb(k); },420);
}
function refreshSheet(){ if(S.sheet){ $sheet.innerHTML=sheetHTML(S.sheet); } }
function sheetHTML(kind){
  if(kind==='guidance') return shGuidance();
  if(kind==='checkin') return shCheckin();
  return '';
}
function sheetHead(title){
  return `<div class="grab"></div><div class="row" style="padding:16px 20px 4px">
    <span style="font-size:18px;font-weight:600;flex:1">${title}</span>
    <button data-act="closesheet" style="width:32px;height:32px;border-radius:50%;background:var(--hair2);
      display:flex;align-items:center;justify-content:center">${ic('close',12,2.3,'var(--ink2)')}</button></div>`;
}

/* -- Guidance (collection steps) -- */
const GSTEPS=[['清水漱口','漱 10 秒后吐掉。别刷牙、别用漱口水，都会让结果不准。'],
  ['等 10 分钟','让嘴里恢复平常的状态，这段时间先别吃喝。'],
  ['含住采样棉 2 分钟','放在舌下，别嚼。泡湿就行，不用使劲。'],
  ['放回管中，封好','不碰棉头，直接放入，按下管盖直到咔哒一声。'],
  ['标注时间点','写上是哪一管、实际几点采的。标错这管就白采了。']];
function shGuidance(){
  const i=S.stepIndex, last=i===GSTEPS.length-1;
  return `<div style="position:relative;height:100%;display:flex;flex-direction:column;background:var(--page)">
    <div style="position:absolute;top:0;left:0;right:0;height:56%;overflow:hidden">
      <img src="Assets/guide${i+1}.png" style="width:100%;height:100%;object-fit:cover;object-position:top">
      <div style="position:absolute;inset:0;background:linear-gradient(180deg,transparent 45%,rgba(237,237,236,.65) 80%,var(--page) 100%)"></div></div>
    <div class="row" style="position:relative;padding:18px 22px 0">
      <span class="row" style="gap:7px;padding:7px 11px;border-radius:99px;background:rgba(255,255,255,.85)">
        <span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
        <span style="font-size:12px;font-weight:600;color:var(--ink2)">每一管都一样</span></span>
      <button data-act="closeguidance" style="margin-left:auto;width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.9);
        display:flex;align-items:center;justify-content:center">${ic('close',13,2.3,'var(--ink2)')}</button></div>
    <div style="flex:1"></div>
    <div style="position:relative;padding:0 22px max(20px, env(safe-area-inset-bottom))">
      <div class="kicker">第 ${i+1} 步 · 共 5 步</div>
      <div style="font-size:26px;font-weight:650;line-height:1.35;margin-top:8px">${GSTEPS[i][0]}</div>
      <div class="zh-loose" style="font-size:13.5px;color:var(--ink2);margin-top:10px">${GSTEPS[i][1]}</div>
      ${i===1||last?`<div class="row" style="gap:8px;margin-top:14px;padding:9px 12px;border-radius:99px;background:rgba(220,245,90,.45);width:fit-content">
        ${ic('bell',12,2,'var(--ink)')}<span style="font-size:12px;font-weight:500;color:var(--ink2)">${last?'其余几管，到点 Aira 会提醒你照做':'Aira 会在 10 分钟后提醒你'}</span></div>`:''}
      <div class="row" style="gap:5px;margin-top:20px">
        ${[0,1,2,3,4].map(k=>`<span style="flex:1;height:3px;border-radius:99px;background:${k<=i?'var(--ink)':'rgba(16,16,17,.12)'}"></span>`).join('')}</div>
      <div class="row" style="gap:10px;margin-top:16px">
        ${i>0?`<button data-act="gback" style="width:52px;height:52px;border-radius:50%;background:#fff;border:1px solid var(--hair);
          display:flex;align-items:center;justify-content:center;flex:none">${ic('chevron',14,2.2,'var(--ink)','transform:rotate(180deg)')}</button>`:''}
        ${cta(last?'五管都采完了':'下一步','data-act="gnext"')}</div></div></div>`;
}

function shCheckin(){
  return sheetHead('打卡')+`
    <div class="scroll" style="padding:14px 22px 40px">
      <div class="zh-loose" style="font-size:13.5px;color:var(--ink2)">手表能测心率，测不了你的感受。一个问题，一天一次。</div>
      <div style="text-align:center;margin-top:28px">${face(S.feel,96,'#3c3c40',2.2)}
        <div style="font-size:19px;font-weight:600;margin-top:10px">${faceNames[S.feel]}</div>
        <div style="font-size:12px;color:var(--ink3);margin-top:2px">${(S.feel+1).toFixed(1)} / 5</div></div>
      <div class="row" style="gap:8px;margin-top:26px">
        ${faceNames.map((n,i)=>`<button data-act="feel" data-v="${i}" style="flex:1;padding:12px 2px;border-radius:16px;
          background:${S.feel===i?'var(--lime)':'#fff'};border:1px solid ${S.feel===i?'var(--lime)':'var(--hair)'};
          display:flex;flex-direction:column;align-items:center;gap:6px">
          ${face(i,26,'#3c3c40',1.6)}<span style="font-size:9px;color:var(--ink2)">${n}</span></button>`).join('')}</div>
      <div style="margin-top:28px">${cta('记录','data-act="logfeel"')}</div>
      <div style="text-align:center;font-size:11px;color:var(--ink3);margin-top:12px">大约 20 秒。Aira 每天只问一次。</div>
    </div>`;
}


/* ================= Demo autoplay ================= */
const DEMO_STEPS=[
  ['欢迎页',2.6,()=>{reset();}],
  ['关于你',2.4,()=>{S.phase='profile';S.profStep=0;S.nickname='Chloe';}],
  ['运动习惯',2.0,()=>{S.phase='profile';S.profStep=1;}],
  ['连接数据',2.2,()=>{S.phase='connect';S.healthGranted=true;}],
  ['导入 30 天',4.8,()=>{beginSync();}],
  ['首读 · 总览',3.0,()=>{S.phase='frintro';}],
  ['首读报告',8.0,()=>{S.phase='firstread';flipReport('frframe',5,1.5);}],
  ['唾液检测指引',3.0,()=>{S.phase='saliva';}],
  ['采样日',2.6,()=>{S.phase='collect';S.saliva=1;}],
  ['采样步骤',3.0,()=>{S.phase='collect';S.stepIndex=2;render();openSheet('guidance');}],
  ['寄出 · 等待',2.4,()=>{closeSheetNow();S.points.forEach(p=>p.done=true);S.phase='waiting';S.saliva=3;}],
  ['联合分析',4.8,()=>{deliverReport();}],
  ['T0 · 总览',3.0,()=>{S.phase='t0intro';S.saliva=4;}],
  ['T0 报告',9.5,()=>{S.phase='t0';S.saliva=4;S.reopenT0=false;flipReport('t0frame',6,1.4);}],
  ['计划 · 推荐',3.6,()=>{S.phase='main';S.tab=2;S.deckOpen=true;}],
  ['加入计划',2.6,()=>{S.phase='main';S.tab=2;S.deckOpen=false;S.plan.acc.add('wind');S.plan.acc.add('early');}],
  ['首页',3.2,()=>{S.phase='main';S.tab=0;}],
  ['问 Aira',3.4,()=>{S.phase='main';S.tab=1;if(!S.sent.includes('为什么先从睡前开始？'))S.sent.push('为什么先从睡前开始？');}],
];
let flipTimer=null;
function flipReport(id,pages,sec){
  clearInterval(flipTimer); let k=0;
  flipTimer=setInterval(()=>{ k++; if(k>=pages||!Demo.playing){ clearInterval(flipTimer); return; } reportGo(id,k); },sec*1000);
}
/* 桌面端控制台在手机壳外，默认展开；手机端保持收起的右缘把手 */
const Demo={playing:false,index:0,
  expanded:window.matchMedia('(min-width:768px) and (min-height:640px)').matches,timer:null};
function closeSheetNow(){ S.sheet=null; $sheet.classList.remove('open'); $veil.classList.remove('open'); $sheet.innerHTML=''; }
function demoRun(i){
  Demo.index=i;
  const [,,fn]=DEMO_STEPS[i];
  fn();
  if(!['syncing','analyzing'].includes(S.phase)&&S.sheet!=='guidance') render();
  renderDemo();
}
function demoPlay(){
  Demo.playing=true;
  const step=(i)=>{
    if(!Demo.playing) return;
    if(i>=DEMO_STEPS.length){ Demo.playing=false; renderDemo(); return; }
    demoRun(i);
    Demo.timer=setTimeout(()=>step(i+1), DEMO_STEPS[i][1]*1000);
  };
  step(0);
}
function demoStop(){ Demo.playing=false; clearTimeout(Demo.timer); clearInterval(flipTimer); renderDemo(); }
function renderDemo(){
  const el=document.getElementById('demo');
  el.className=Demo.expanded?'expanded':'';
  el.innerHTML=`${Demo.expanded?`<div class="panel">
      <div class="head"><button class="pp" data-demo="toggle">${Demo.playing?pauseGlyph():playGlyph('var(--ink)')}</button>
        <span>${Demo.playing?DEMO_STEPS[Math.min(Demo.index,DEMO_STEPS.length-1)][0]:'播放完整流程'}</span></div>
      <div class="steps">${DEMO_STEPS.map((s,i)=>`<button class="${i===Demo.index?'cur':''}" data-demo="jump" data-v="${i}">
        <span class="d"></span>${i+1}. ${s[0]}</button>`).join('')}</div></div>`:''}
    <button class="handle" data-demo="expand">
      <span class="pbtn ${Demo.playing?'playing':''}">${Demo.playing?pauseGlyph():playGlyph('#fff')}</span>
      <span class="lbl">DEMO</span></button>`;
  if(Demo.expanded){ const cur=el.querySelector('.steps .cur'); if(cur) cur.scrollIntoView({block:'center'}); }
}
function playGlyph(c){ return `<svg width="11" height="12" viewBox="0 0 11 12"><path d="M1.5 1l8 5-8 5z" fill="${c}"/></svg>`; }
function pauseGlyph(){ return `<svg width="10" height="12" viewBox="0 0 10 12"><rect x="1" width="3" height="12" rx="1.5" fill="#101011"/><rect x="6" width="3" height="12" rx="1.5" fill="#101011"/></svg>`; }

/* ================= Event wiring ================= */
function act(el){
  const a=el.dataset.act, v=el.dataset.v;
  switch(a){
    case 'backprof': S.phase='profile'; S.profStep=1; render(); break;
    case 'getstarted': S.phase='profile'; S.profStep=0; render(); break;
    case 'phase': S.phase=v; render(); break;
    case 'grant': S.healthGranted=true; render(); break;
    case 'device': S.devices.has(v)?S.devices.delete(v):S.devices.add(v); render(); break;
    case 'connectnext': if(S.healthGranted) beginSync(); else {S.healthGranted=true; render();} break;
    case 'profstep': S.profStep=+v; render(); break;
    case 'sex': S.sex=+v; render(); break;
    case 'band': S.sessionBand=+v; render(); break;
    case 'finishonb': S.phase='connect'; render(); break;
    /* 唾液主线 */
    case 'schedule': S.saliva=1; S.phase='collect'; render(); break;
    case 'guide': S.stepIndex=0; openSheet('guidance'); break;
    case 'gback': S.stepIndex--; refreshSheet(); break;
    case 'gnext':
      if(S.stepIndex===GSTEPS.length-1){
        S.points.forEach(p=>p.done=true); S.saliva=3;
        closeSheet(()=>{ S.phase='waiting'; render(); });
      } else { S.stepIndex++; refreshSheet(); }
      break;
    case 'closeguidance': closeSheet(()=>render()); break;
    case 'fastforward': deliverReport(); break;
    /* T0 报告：主界面里随时重开 */
    case 'opent0': if(S.sheet) closeSheetNow(); S.reopenT0=true; S.phase='t0'; render(); break;
    case 'closet0': S.phase='main'; render(); break;
    case 'openfr': if(S.sheet) closeSheetNow(); S.reopenFR=true; S.phase='firstread'; render(); break;
    case 'closefr': S.phase='main'; render(); break;
    /* 主界面 */
    case 'tab': S.tab=+v; if(S.tab===1)S.unread=0; if(S.sheet)closeSheet(); render(); break;
    case 'sheet': openSheet(v); break;
    case 'closesheet': closeSheet(); break;
    case 'send': send(v); break;
    case 'composer': {
      const inp=document.getElementById('composer');
      if(inp&&inp.value.trim()) send(inp.value.trim());
      break; }
    case 'pacc': if(S.plan.acc.has(v)){ S.plan.acc.delete(v); toast('已从计划移出'); } else { S.plan.acc.add(v); S.plan.skip.delete(v); toast('已加入本周计划'); } render(); break;
    case 'pday': if(S.plan.day!==+v){ S.plan.day=+v; S._dayAnim=true; } render(); break;
    case 'deckopen': S.deckOpen=!S.deckOpen; render(); break;
    case 'restoreskipped': S.plan.skip.clear(); render(); break;
    case 'pdone': {
      if(S.plan.done.has(v)){ S.plan.done.delete(v); render(); break; }
      S.plan.done.add(v);
      const d=+v.split('-')[0], its=dayItems(d), all=its.length&&its.every(x=>S.plan.done.has(d+'-'+x.key));
      render(); if(all) celebrate(d,its.length); else toast('完成一项');
      break; }
    case 'feel': S.feel=+v; refreshSheet(); break;
    case 'logfeel': S.loggedToday=true; closeSheet(()=>{ render(); toast('记下了'); }); break;
  }
}
document.addEventListener('click',e=>{
  const demoBtn=e.target.closest('[data-demo]');
  if(demoBtn){
    const d=demoBtn.dataset.demo;
    if(d==='expand'){ Demo.expanded=!Demo.expanded; renderDemo(); }
    else if(d==='toggle'){ Demo.playing?demoStop():demoPlay(); }
    else if(d==='jump'){ demoStop(); demoRun(+demoBtn.dataset.v); }
    return;
  }
  const qa=e.target.closest('[data-qa]');
  if(qa){ const b=document.getElementById('qa-'+qa.dataset.qa);
    if(b) b.style.display=b.style.display==='none'?'block':'none'; return; }
  const el=e.target.closest('[data-act]');
  if(el) act(el);
});
document.getElementById('sheetveil').addEventListener('click',()=>closeSheet());
document.addEventListener('keydown',e=>{
  if(e.key==='Enter'&&e.target.id==='composer'&&e.target.value.trim()){ send(e.target.value.trim()); }
  if(e.key==='Enter'&&e.target.id==='nick'){ e.target.blur(); }
});
document.addEventListener('input',e=>{
  if(e.target.id==='nick'){ S.nickname=e.target.value; }
  if(e.target.dataset.ruler){
    const k=e.target.dataset.ruler; S[k]=+e.target.value;
    const val=e.target.closest('.ruler').querySelector('.val');
    val.innerHTML=`${S[k]}<span>${k==='age'?'岁':'年'}</span>`;
  }
});

/* scrubber + self trend + deck swipe need per-render wiring */
function wireScreen(){
  const card=document.getElementById('topcard');
  if(card){
    let x0=null,dx=0;
    const hints=()=>document.getElementById('swipehints');
    card.addEventListener('pointerdown',e=>{ if(e.target.closest('[data-act]')) return; x0=e.clientX; dx=0; card.setPointerCapture(e.pointerId); });
    card.addEventListener('pointermove',e=>{ if(x0==null) return; dx=e.clientX-x0;
      card.style.transition='none'; card.style.transform=`translateX(${dx}px) rotate(${dx/24}deg)`;
      const h=hints(); if(h) h.style.opacity=Math.abs(dx)>24?1:0; });
    card.addEventListener('pointerup',()=>{ if(x0==null) return; x0=null;
      if(dx>96) deckDecide(1); else if(dx<-96) deckDecide(-1);
      else { card.style.transition='transform .3s cubic-bezier(.3,.9,.4,1.2)'; card.style.transform='none'; const h=hints(); if(h) h.style.opacity=0; } });
  }
  document.querySelectorAll('[data-self]').forEach(b=>b.addEventListener('click',()=>{
    S.selfSelected=+b.dataset.self; render();
  }));
}

/* 报告页（首读 / T0）：去掉报告自带的手机框，顶部让出状态栏 */
function patchReport(id){
  const f=document.getElementById(id);
  const go=()=>{ try{
    const d=f.contentDocument; if(!d||!d.head||d.getElementById('host-patch')) return;
    if(id==='frframe') d.body.dataset.cta=S.reopenFR?'回到首页':'继续';
    const st=d.createElement('style'); st.id='host-patch';
    st.textContent='#phone{width:100%!important;height:100%!important;border-radius:0!important;box-shadow:none!important}'+
      '#bars{top:max(30px,env(safe-area-inset-top))!important}.closable #bars{right:62px!important}.page{padding-top:max(64px,calc(env(safe-area-inset-top) + 44px))!important}';
    d.head.appendChild(st);
  }catch(e){} };
  f.addEventListener('load',go); go();
}
patchReport('frframe'); patchReport('t0frame');
document.getElementById('phone').addEventListener('scroll',e=>{ e.target.scrollTop=0; });
/* 报告末页 CTA 通过 postMessage 回到主线 */
window.addEventListener('message',e=>{
  const m=e.data||{}; if(m.aira!=='report-done') return;
  if(m.which==='first-read'&&S.phase==='firstread'){ if(S.reopenFR){ S.phase='main'; S.tab=0; } else { S.phase='saliva'; } render(); }
  else if(m.which==='t0'&&S.phase==='t0'){ S.phase='main'; S.tab=2; render(); }
});

/* boot */
render();

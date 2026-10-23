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
  sleepBase: 7.4667,
  hpaUser: [4.20, 5.53, 2.33, 1.69, 1.29],
  hpaBalanced: [4.00, 6.20, 1.48, 0.79, 0.46],
  selfCheck: [2.1, 2.8, 3.1, 3.6, 4.2, 3.4, null, 2.2, 2.9, 3.8, 4.1, 3.3, 2.4, 1.8],
  days: [
    {date:'10/01',wd:'周三',sleep:'7:22',sd:-6, wk:1,am:7, longest:'4:40',onset:'23:35',od:-5, rec:44,rd:-3, hrv:50,rhr:57,steps:'10,210'},
    {date:'10/02',wd:'周四',sleep:'7:10',sd:-18,wk:1,am:10,longest:'4:05',onset:'23:45',od:5,  rec:46,rd:-1, hrv:49,rhr:57,steps:'9,640'},
    {date:'10/03',wd:'周五',sleep:'6:48',sd:-40,wk:2,am:16,longest:'3:20',onset:'00:02',od:22, rec:50,rd:3,  hrv:47,rhr:58,steps:'8,980'},
    {date:'10/04',wd:'周六',sleep:'7:35',sd:7,  wk:1,am:8, longest:'4:55',onset:'23:50',od:10, rec:43,rd:-4, hrv:51,rhr:56,steps:'6,320'},
    {date:'10/05',wd:'周日',sleep:'7:04',sd:-24,wk:2,am:13,longest:'3:45',onset:'23:58',od:18, rec:47,rd:0,  hrv:48,rhr:58,steps:'7,450'},
    {date:'10/06',wd:'周一',sleep:'6:58',sd:-30,wk:2,am:15,longest:'3:30',onset:'00:00',od:20, rec:49,rd:2,  hrv:48,rhr:58,steps:'9,120'},
    {date:'10/07',wd:'周二',sleep:'6:50',sd:-38,wk:2,am:17,longest:'3:10',onset:'00:05',od:25, rec:52,rd:5,  hrv:46,rhr:59,steps:'8,700'},
    {date:'10/08',wd:'周三',sleep:'7:06',sd:-22,wk:1,am:9, longest:'4:10',onset:'23:50',od:10, rec:51,rd:4,  hrv:47,rhr:58,steps:'9,140'},
    {date:'10/09',wd:'周四',sleep:'6:54',sd:-34,wk:2,am:18,longest:'3:05',onset:'00:05',od:25, rec:55,rd:8,  hrv:45,rhr:59,steps:'7,820'},
    {date:'10/10',wd:'周五',sleep:'—',  sd:0,  wk:0,am:0, longest:'—',  onset:'—',  od:0,  rec:0, rd:0,  hrv:0, rhr:0, steps:'—'},
    {date:'10/11',wd:'周六',sleep:'6:12',sd:-76,wk:4,am:51,longest:'1:40',onset:'00:40',od:60, rec:68,rd:21, hrv:38,rhr:63,steps:'5,410'},
    {date:'10/12',wd:'周日',sleep:'6:36',sd:-52,wk:3,am:35,longest:'2:20',onset:'00:20',od:40, rec:61,rd:14, hrv:41,rhr:61,steps:'8,900'},
    {date:'10/13',wd:'周一',sleep:'6:24',sd:-64,wk:3,am:42,longest:'2:00',onset:'00:30',od:50, rec:64,rd:17, hrv:40,rhr:62,steps:'8,260'},
    {date:'10/14',wd:'周二',sleep:'6:31',sd:-57,wk:2,am:26,longest:'2:45',onset:'00:15',od:35, rec:60,rd:13, hrv:42,rhr:61,steps:'6,180'},
  ],
  hm(s){ const p=s.split(':').map(Number); return p.length===2 ? p[0]+p[1]/60 : 0; },
  recent(n){ return this.days.slice(-n); },
  avg(n,f){ const v=this.recent(n).filter(d=>d.sleep!=='—').map(f); return v.reduce((a,b)=>a+b,0)/v.length; },
  avgSleepText(n){ const h=this.avg(n,d=>this.hm(d.sleep)); const m=Math.round(h*60);
    return `${Math.floor(m/60)}:${String(m%60).padStart(2,'0')}`; },
};
const RANGES = [ {t:'7天',days:7,base:'前 28 天基线',grain:'按日'},
                 {t:'14天',days:14,base:'前 14 天',grain:'按日'},
                 {t:'30天',days:14,base:'前 90 天基线',grain:'按日'} ];
const STATES = ['耗竭','平衡','激活','紧绷','过载'];

/* ================= State (App in Model.swift) ================= */
const S = {
  phase:'welcome', tab:0, profStep:0,
  nickname:'', age:32, sex:0, sessionBand:1, years:2,
  injuries:new Set(), meds:new Set(),
  healthGranted:false, devices:new Set(), syncedItems:0,
  saliva:0, // 0 未安排 1 已安排 2 采集中 3 已寄出 4 报告已出
  points:[
    {name:'C1 · 醒后 30 分钟', when:'06:45', hint:'留在床上，起身活动前先取第一管', done:false},
    {name:'C2 · 醒后 45 分钟', when:'07:15', hint:'C1 后 30 分钟 —— 这一对决定 CAR', done:false},
    {name:'C3 · 午餐前',       when:'11:30', hint:'进食前采样，避免食物干扰', done:false},
    {name:'C4 · 16–17 点',     when:'16:30', hint:'午后低谷', done:false},
    {name:'C5 · 睡前',         when:'22:30', hint:'决定性的一管 —— 它决定状态分组', done:false},
  ],
  activePoint:null, stepIndex:0, retestScheduled:false,
  sent:[], unread:2,
  dayIndex:Mock.days.length-1, range:0,
  selfSelected:13, loggedToday:false, feel:2,
  sheet:null, sheetArg:null,
  deckExpanded:false, reportChapter:0,
  arranged:[], planSeg:0,
  deviceRecs:[
    {tag:'活动',col:'var(--sky)',title:'每小时站立 2 分钟',
     because:'你从 13:10 到 15:50 连续坐了 2 小时 40 分 —— 正好压在精力低谷上。',
     evidence:['活动 · 7天','14:00 自评'],constraint:'工作日 · 今天下午就开始',
     timeline:'几天内可感知',impact:null,saliva:false,state:0,done:0},
    {tag:'睡眠',col:'var(--violet)',title:'22:30 放下手机',
     because:'近 5 天入睡点中位数是 00:30 —— 比你的基线晚了 50 分钟。',
     evidence:['入睡点 · 5天','基线 28天'],constraint:'每天 · 先试一周',
     timeline:'入睡点通常 1–2 周内前移',impact:null,saliva:false,state:0,done:0},
    {tag:'活动',col:'var(--sky)',title:'下午快走 20 分钟',
     because:'这周只有 2 次运动，而周六是你睡得最碎的一夜。',
     evidence:['运动 · 7天','睡眠 10/12'],constraint:'每周 3 次 · 不加强度',
     timeline:'一周内可感知',impact:null,saliva:false,state:0,done:0},
  ],
  reportRecs:[
    {tag:'生活方式',col:'var(--sky)',title:'固定起床时间（±30 分钟）',
     because:'唯一同时作用于两端的杠杆 —— 晨间上升与夜间关机。定住起床时间，入睡点会自己前移。',
     evidence:['CAR 32%','入睡点 · 5天','AUCg 33.3'],constraint:'每天 · 优先级高于补剂和运动',
     timeline:'约 2 周有感 · 6 周完整效果',impact:9.1,saliva:true,state:0,done:0},
    {tag:'呼吸练习',col:'var(--lime)',title:'睡前 10 分钟缓慢呼吸',
     because:'你的夜间皮质醇一直降不下来（睡前 1.29，平衡值 0.4）—— 这个练习正好打在这个点上。',
     evidence:['睡前皮质醇 1.29','HRV · 14天'],constraint:'每周 5 次 · 晚间不安排其他任务',
     timeline:'约 2 周有感',impact:8.4,saliva:true,state:0,done:0},
    {tag:'营养',col:'var(--amber)',title:'午餐碳水控制在 40 g 以内',
     because:'14:00–16:00 是你皮质醇最低的窗口 —— 午餐碳水过重会加深这个低谷。',
     evidence:['16:30 皮质醇 1.69','14:00 自评'],constraint:'工作日 · 针对午后低谷',
     timeline:'约 1 周可感知',impact:7.2,saliva:true,state:0,done:0},
  ],
};
const stage = () => S.saliva===4 ? S.reportRecs : S.deviceRecs;
const deck  = () => stage().filter(r=>r.state===0);
const accepted = () => [...S.deviceRecs,...S.reportRecs].filter(r=>r.state===1);
const nick = () => S.nickname.trim() || 'Chloe';
const donePts = () => S.points.filter(p=>p.done).length;
const BIOTIN = '生物素（维生素 B7）';

function reset(){
  Object.assign(S,{phase:'welcome',tab:0,profStep:0,nickname:'',healthGranted:false,syncedItems:0,
    saliva:0,activePoint:null,stepIndex:0,retestScheduled:false,sent:[],unread:2,
    dayIndex:Mock.days.length-1,range:0,loggedToday:false,sheet:null,reportChapter:0,arranged:[],planSeg:0});
  S.injuries.clear(); S.meds.clear(); S.devices.clear();
  S.points.forEach(p=>p.done=false);
  [...S.deviceRecs,...S.reportRecs].forEach(r=>{r.state=0;r.done=0;});
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
function stateStrip(here){
  return `<div class="statestrip">`+STATES.map((n,i)=>
    `<div class="st ${i===here?'here':''}"><i></i><span>${n}</span></div>`).join('')+`</div>`;
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

function hpaDeviation(w=312,h=150){
  const u=Mock.hpaUser,b=Mock.hpaBalanced,max=6.6;
  const pl=8,pr=30,pt=10,pb=28;
  const X=i=>pl+(w-pl-pr)*i/4, Y=v=>pt+(h-pt-pb)*(1-v/max);
  const up=u.map((v,i)=>[X(i),Y(v)]), bp=b.map((v,i)=>[X(i),Y(v)]);
  const pu=smoothPath(up), pb2=smoothPath(bp);
  const area=(i0,i1,col)=>{
    const rev=bp.slice(i0,i1+1).reverse();
    let d2=smoothPath(up.slice(i0,i1+1));
    const revd=smoothPath(rev);
    return `<path d="${d2} L${rev[0][0].toFixed(1)} ${rev[0][1].toFixed(1)} ${revd.slice(revd.indexOf('C')>0?revd.indexOf('C'):1)} Z" fill="${col}" opacity=".32"/>`;
  };
  const labels=['醒来','+30分','午餐前','16–17','睡前'];
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=area(0,1,'var(--sky)')+area(1,4,'var(--coral)');
  s+=`<path d="${pb2}" stroke="rgba(255,255,255,.45)" stroke-width="1.3" stroke-dasharray="3 3" fill="none"/>`;
  s+=`<path d="${pu}" stroke="var(--amber)" stroke-width="2.2" fill="none" stroke-linecap="round"/>`;
  u.forEach((v,i)=>{ s+=`<circle cx="${X(i)}" cy="${Y(v)}" r="3.4" fill="var(--amber)"/>`; });
  s+=`<circle cx="${X(4)}" cy="${Y(u[4])}" r="5.4" fill="#fff"/>`;
  s+=`<text x="${X(4)-2}" y="${Y(u[4])-11}" fill="#fff" font-size="11" font-weight="600" text-anchor="end">1.29</text>`;
  labels.forEach((l,i)=>{ s+=`<text x="${X(i)}" y="${h-12}" fill="rgba(255,255,255,.4)" font-size="9"
      text-anchor="${i===0?'start':i===4?'end':'middle'}" ${i===4?'font-weight="700" fill="#fff"':''}>${l}</text>`; });
  s+=`<text x="${X(4)}" y="${h-1}" fill="rgba(255,255,255,.35)" font-size="8" text-anchor="end">决定点</text>`;
  return s+'</svg>';
}
function fiveTubesCurve(w=300,h=96){
  const v=[0.52,0.92,0.42,0.22,0.12], labels=['醒来','+30分','午餐前','16–17点','睡前'];
  const pl=10,pr=10,pt=12,pb=24;
  const X=i=>pl+(w-pl-pr)*i/4, Y=x=>pt+(h-pt-pb)*(1-x);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">
    <path d="${smoothPath(v.map((x,i)=>[X(i),Y(x)]))}" stroke="var(--lime)" stroke-width="2" fill="none" stroke-linecap="round"/>`;
  v.forEach((x,i)=>{ s+=`<circle cx="${X(i)}" cy="${Y(x)}" r="4" fill="#151514" stroke="var(--lime)" stroke-width="2"/>
    <text x="${X(i)}" y="${h-8}" fill="rgba(255,255,255,.45)" font-size="8.6" text-anchor="${i===0?'start':i===4?'end':'middle'}">${labels[i]}</text>`;});
  return s+'</svg>';
}
function sleepAxis(day,w=312,h=92){
  const total=Mock.hm(day.sleep), longest=Mock.hm(day.longest), n=Math.max(1,day.wk);
  const segs=[]; segs.push({len:longest,sleep:true,main:true});
  const rest=Math.max(0.2,total-longest), per=rest/n, gap=(day.am/n)/60;
  for(let i=0;i<n;i++){ segs.push({len:gap,sleep:false}); segs.push({len:per,sleep:true}); }
  const span=segs.reduce((a,s)=>a+s.len,0);
  const pl=2,pr=2,bt=24,bh=34;
  let x=pl, s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=`<text x="${pl}" y="12" fill="rgba(255,255,255,.35)" font-size="9">22:30</text>
      <text x="${w-pr}" y="12" fill="rgba(255,255,255,.35)" font-size="9" text-anchor="end">07:59</text>
      <text x="${w/2}" y="12" fill="rgba(255,255,255,.75)" font-size="9.5" font-weight="600" text-anchor="middle">最长连续段 ${day.longest}</text>`;
  let mainX=0,mainW=0;
  segs.forEach(seg=>{
    const sw=(w-pl-pr)*seg.len/span;
    if(seg.sleep){
      const stripes=Math.max(1,Math.round(sw/14));
      for(let k=0;k<stripes;k++){
        const op=[0.95,0.5,0.75,0.35][k%4];
        s+=`<rect x="${(x+k*sw/stripes).toFixed(1)}" y="${bt}" width="${(sw/stripes-1.6).toFixed(1)}" height="${bh}" rx="3" fill="rgba(220,245,90,${op*0.8})"/>`;
      }
      if(seg.main){mainX=x;mainW=sw;}
    }
    x+=sw;
  });
  s+=`<rect x="${(mainX-3).toFixed(1)}" y="${bt-4}" width="${(mainW+6).toFixed(1)}" height="${bh+8}" rx="9" fill="none" stroke="rgba(255,255,255,.75)" stroke-width="1.4"/>`;
  s+=`<path d="M${pl+4} ${bt-6} v${bh+14}" stroke="var(--coral)" stroke-width="1.6" stroke-dasharray="3 3"/>
      <circle cx="${pl+4}" cy="${bt+bh+8}" r="3.4" fill="var(--coral)"/>
      <text x="${pl+14}" y="${h-4}" fill="var(--coral)" font-size="9.4">入睡 ${day.onset} · 比平时晚 ${day.od} 分钟</text>`;
  return s+'</svg>';
}
function stressTide(level,w=312,h=86){
  const waves=[{a:0.9,f:1.7,op:1,sw:2.2,col:'var(--lime)'},{a:0.55,f:2.6,op:.5,sw:1.4,col:'var(--lime)'},
               {a:0.4,f:3.4,op:.35,sw:1.2,col:'#fff'},{a:0.3,f:2.1,op:.3,sw:1.2,col:'#fff'}];
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  waves.forEach((wv,wi)=>{
    const pts=[]; const amp=(8+level*22)*wv.a;
    for(let i=0;i<=40;i++){ const x=w*i/40;
      pts.push([x, h/2 + Math.sin(i/40*Math.PI*2*wv.f + wi*1.7)*amp*(0.6+0.4*Math.sin(i/40*Math.PI)) ]); }
    s+=`<path d="${smoothPath(pts)}" stroke="${wv.col}" stroke-width="${wv.sw}" opacity="${wv.op}" fill="none"/>`;
  });
  return s+'</svg>';
}
function sleepScrubber(){
  const n=Math.min(RANGES[S.range].days, Mock.days.length);
  const idx=[...Array(n).keys()].map(i=>Mock.days.length-n+i);
  const w=352,hh=132, pl=26,pr=14,top=36,bot=26;
  const lo=4.5,hi=9.5;
  const X=i=>pl+(w-pl-pr)*i/Math.max(1,n-1), Y=v=>top+(hh-top-bot)*(1-(v-lo)/(hi-lo));
  const vals=idx.map(i=>Mock.days[i].sleep==='—'?0:Mock.hm(Mock.days[i].sleep));
  let sel=idx.indexOf(S.dayIndex); if(sel<0) sel=n-1;
  const d=Mock.days[idx[sel]];
  let s=`<svg width="100%" viewBox="0 0 ${w} ${hh}" style="display:block">`;
  [5,7,9].forEach(g=>{ s+=`<path d="M${pl} ${Y(g)}H${w-pr}" stroke="var(--hair)" stroke-width="1"/>
    <text x="10" y="${Y(g)+3}" fill="var(--ink3)" font-size="9">${g}h</text>`;});
  s+=`<path d="M${pl} ${Y(Mock.sleepBase)}H${w-pr}" stroke="var(--ink3)" stroke-width="1" stroke-dasharray="3 3"/>`;
  const pts=vals.map((v,i)=>v>0?[X(i),Y(v)]:null).filter(Boolean);
  s+=`<path d="${smoothPath(pts)}" stroke="var(--ink)" stroke-width="2" fill="none"/>`;
  vals.forEach((v,i)=>{ if(v===0) s+=`<circle cx="${X(i)}" cy="${Y(6.8)}" r="3" fill="none" stroke="var(--ink3)" stroke-width="1" stroke-dasharray="1.5 1.5"/>`;});
  s+=`<path d="M${X(sel)} ${top-6}V${hh-bot+4}" stroke="rgba(16,16,17,.18)" stroke-width="1"/>`;
  s+=`<circle cx="${X(sel)}" cy="${Y(Math.max(lo+0.1,vals[sel]>0?vals[sel]:6.8))}" r="6" fill="#fff" stroke="var(--ink)" stroke-width="2"/>`;
  idx.forEach((di,i)=>{ if(S.range===0||i%2===0)
    s+=`<text x="${X(i)}" y="${hh-6}" fill="${i===sel?'var(--ink)':'var(--ink3)'}" font-size="9"
        ${i===sel?'font-weight="600"':''} text-anchor="middle">${Mock.days[di].date.slice(3)}</text>`;});
  s+='</svg>';
  return `<div style="position:relative" id="scrub" data-n="${n}">
    <div style="position:absolute;left:26px;top:0">
      <div style="font-size:14px;font-weight:600;color:var(--ink)">${d.sleep==='—'?'该日无数据':'睡眠 '+d.sleep}</div>
      <div style="font-size:10.5px;color:var(--ink3);margin-top:2px">${d.sleep==='—'?`${d.wd} ${d.date}`:`${d.wd} ${d.date} · 入睡 ${d.onset} · 醒 ${d.wk} 次`}</div>
    </div>${s}</div>`;
}
function selfTrend(){
  const vals=Mock.selfCheck, n=vals.length;
  const w=352,hh=120,pl=14,pr=14,top=18,bot=24;
  const X=i=>pl+(w-pl-pr)*i/(n-1), Y=v=>top+(hh-top-bot)*(1-(v-1)/3.4);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${hh}" style="display:block">`;
  s+=`<text x="${pl}" y="12" fill="var(--ink3)" font-size="9">紧绷</text>
      <text x="${pl}" y="${hh-2}" fill="var(--ink3)" font-size="9">平静</text>
      <text x="${w-pr}" y="${hh-2}" fill="var(--ink3)" font-size="9" text-anchor="end">10/14</text>
      <text x="${pl+34}" y="${hh-2}" fill="var(--ink3)" font-size="9">10/01</text>`;
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
function dayRibbon(w=312,h=96){
  const act=[[7,.62],[8,.78],[9,.3],[10,.22],[11,.18],[12,.2],[13,.08],[14,.06],[15,.07],[16,.16],[17,.26],[18,.7],[19,.55],[20,.3],[21,.12]];
  const pl=6,pr=6,base=h-30;
  const X=hr=>pl+(w-pl-pr)*(hr-7)/14;
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=`<rect x="${X(13.17)}" y="14" width="${X(15.83)-X(13.17)}" height="${base-14}" rx="6" fill="rgba(255,138,91,.14)" stroke="rgba(255,138,91,.5)" stroke-width="1" stroke-dasharray="3 3"/>`;
  act.forEach(([hr,v])=>{ const bw=(w-pl-pr)/15-3;
    s+=`<rect x="${X(hr)-bw/2}" y="${base-v*58}" width="${bw}" height="${v*58}" rx="3" fill="rgba(220,245,90,${0.25+v*0.65})"/>`;});
  const en=[[8,5],[10,4],[12,4],[14,2],[16,2],[18,3],[20,3]];
  const Ye=v=>base-8-(v-1)/4*46;
  s+=`<path d="${smoothPath(en.map(([hr,v])=>[X(hr),Ye(v)]))}" stroke="#fff" stroke-width="1.6" opacity=".7" fill="none"/>`;
  s+=`<circle cx="${X(14)}" cy="${Ye(2)}" r="3.4" fill="var(--coral)"/>
      <text x="${X(14)+7}" y="${Ye(2)+3}" fill="var(--coral)" font-size="9">自评 2 分</text>`;
  [7,12,17,21].forEach(hr=>{ s+=`<text x="${X(hr)}" y="${h-10}" fill="rgba(255,255,255,.35)" font-size="9" text-anchor="middle">${hr}:00</text>`;});
  s+=`<text x="${X(14.5)}" y="10" fill="rgba(255,138,91,.9)" font-size="9" text-anchor="middle">久坐 2 小时 40 分</text>`;
  return s+'</svg>';
}
function devRow(name,value,pos,bandLo,bandHi){
  const inBand=pos>=bandLo&&pos<=bandHi, c=inBand?'var(--lime)':'var(--coral)';
  return `<div class="row" style="gap:12px;padding:9px 0">
    <div style="width:76px;font-size:12px;color:var(--onD2)">${name}</div>
    <div style="flex:1;position:relative;height:10px">
      <div style="position:absolute;inset:2px 0;border-radius:99px;background:rgba(255,255,255,.08)"></div>
      <div style="position:absolute;top:2px;bottom:2px;left:${bandLo*100}%;width:${(bandHi-bandLo)*100}%;border-radius:99px;background:rgba(255,255,255,.16)"></div>
      <div style="position:absolute;top:0.5px;left:calc(${pos*100}% - 4.5px);width:9px;height:9px;border-radius:50%;
           background:${c};box-shadow:0 0 5px ${c}"></div>
    </div>
    <div style="width:58px;text-align:right;font-size:12.5px;font-weight:600;font-variant-numeric:tabular-nums">${value}</div></div>`;
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
function statTrio(items){
  return `<div><div class="hair-d" style="margin:14px 0 13px"></div><div class="row" style="align-items:flex-start;gap:8px">`+
    items.map(it=>`<div style="flex:1"><div class="num" style="font-size:16px">${it.v}</div>
      <div style="font-size:10px;color:var(--onD3);margin-top:3px">${it.k}</div></div>`).join('')+`</div></div>`;
}
function sectionLabel(t){ return `<div class="sectionlabel">${t}</div>`; }

/* ================= Cards shared between Recap / Home / Agent ================= */
function recoveryCardHTML(){
  const day=Mock.days[Mock.days.length-2];
  return `<div class="fog warm"><div class="bg"></div><div class="pad">
    ${cardHead('recover','恢复负荷',`${RANGES[S.range].t}窗口 · 对比${RANGES[S.range].base}`)}
    <div class="row" style="align-items:flex-end;gap:10px;margin-top:14px">
      <div class="num" style="font-size:46px;line-height:1">${day.rec}</div>
      <div style="flex:1"><div style="font-size:11px;color:var(--onD3)">满分 100</div>
        <div style="font-size:12.5px;font-weight:600;color:var(--coral)">负荷偏高</div></div>
      <div style="text-align:right"><div style="font-size:10.5px;color:var(--onD3)">对比基线</div>
        <div class="num" style="font-size:16px;color:var(--coral)">+${day.rd}</div></div></div>
    <div style="margin-top:10px;position:relative">${stressTide(day.rec/100)}
      <div style="position:absolute;left:0;bottom:0;font-size:9.5px;color:var(--onD3)">基线 47</div></div>
    <div class="hair-d" style="margin-top:12px"></div>
    ${devRow('睡眠',day.sleep,(Mock.hm(day.sleep)-5.5)/2.5,0.58,0.95)}
    ${devRow('心率变异性',day.hrv+' ms',(day.hrv-34)/22,0.45,0.9)}
    ${devRow('静息心率',day.rhr+' bpm',(day.rhr-54)/12,0.08,0.58)}
  </div></div>`;
}
function nightCardHTML(day,compact=false){
  const mins=h=>{const m=Math.round(h*60);return `${Math.floor(m/60)}h${String(m%60).padStart(2,'0')}m`;};
  const deep=mins(Mock.hm(day.sleep)*0.20), rem=mins(Mock.hm(day.sleep)*0.25);
  return `<div class="fog warm"><div class="bg"></div><div class="pad">
    ${cardHead('moon','昨夜',`${day.date} · Apple Watch`, day.wk>=3?'碎片化':'连续', day.wk>=3?'warn':'good')}
    <div class="row" style="justify-content:space-between;align-items:baseline;margin-top:13px">
      <span class="num" style="font-size:36px">${day.sleep}</span>
      <span style="font-size:12.5px;font-weight:600;color:var(--coral)">↓ ${Math.abs(day.sd)} 分钟</span></div>
    <div style="font-size:10.5px;color:var(--onD3);margin-top:4px">基线 7:28 · 前 28 天 · 已剔除 10/10</div>
    <div style="margin-top:12px">${sleepAxis(day)}</div>
    ${statTrio([{v:deep,k:'深睡 20%'},{v:rem,k:'REM 25%'},{v:`${day.wk} 次 · ${day.am}分`,k:'觉醒'}])}
  </div></div>`;
}

/* ================= Screens ================= */
const $screen=document.getElementById('screen');
const $sheet=document.getElementById('sheet');
const $veil=document.getElementById('sheetveil');

function render(){
  let html='';
  switch(S.phase){
    case 'welcome': html=vWelcome(); break;
    case 'connect': html=vConnect(); break;
    case 'syncing': html=vSyncing(); break;
    case 'recap':   html=''; break;   // 首读报告由 #frhost 的 iframe（first-read.html）承载
    case 'profile': html=vProfile(); break;
    case 'medical': html=vMedical(); break;
    case 'main':    html=vMain(); break;
  }
  $screen.innerHTML=html;
  // 计划 tab / 首读报告由常驻 iframe 原型页承载，状态不随切换重置
  document.getElementById('planhost').classList.toggle('show', S.phase==='main'&&S.tab===2);
  document.getElementById('frhost').classList.toggle('show', S.phase==='recap');
  wireScreen();
  renderDemo();
  if(S.phase==='main'&&S.tab===1){
    const sc=document.getElementById('threadscroll');
    if(sc) sc.scrollTop=sc.scrollHeight;
  }
}

/* ---- 1 Welcome ---- */
function vWelcome(){
  return `<div class="view"><div class="fogscreen warm"></div>
  <div style="position:relative;display:flex;flex-direction:column;height:100%;padding:0 22px;
       padding-top:max(20px, env(safe-area-inset-top));padding-bottom:max(16px, env(safe-area-inset-bottom))">
    <div class="row" style="justify-content:space-between;padding-top:4px">
      <span style="font-size:12px;font-weight:700;letter-spacing:4px;color:rgba(255,255,255,.9)">A I R A</span>
      <span style="font-size:10px;font-weight:600;letter-spacing:1px;color:rgba(255,255,255,.75);
            padding:5px 9px;border-radius:99px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.14)">抢先体验</span></div>
    <div style="flex:1 0 10px;max-height:26px"></div>
    <div class="appearup" style="position:relative;padding-right:56px">
      <div class="glass" style="border-radius:20px;padding:14px">
        <div class="row" style="gap:8px"><span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
          <span style="font-size:9.5px;font-weight:700;letter-spacing:2px;color:rgba(255,255,255,.55)">皮质醇 · 单日曲线</span>
          <span style="margin-left:auto;font-size:9px;color:rgba(255,255,255,.35)">ng/mL</span></div>
        <div style="margin-top:10px">${cortisolSketch()}</div>
        <div class="row" style="gap:4px;margin-top:10px">
          ${STATES.map((s,i)=>`<div style="flex:1;text-align:center">
            <div style="height:3px;border-radius:99px;background:${i===3?'var(--lime)':'rgba(255,255,255,.16)'}"></div>
            <div style="font-size:8.5px;margin-top:5px;color:${i===3?'#fff':'rgba(255,255,255,.3)'};${i===3?'font-weight:700':''}">${s}</div></div>`).join('')}</div>
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
    <div style="flex:1 0 10px;max-height:28px"></div>
    <div class="serif appearup" style="font-size:34px;font-weight:600;color:#fff;line-height:1.3">压力不是<br>一种感觉。</div>
    <div class="serif appearup" style="font-size:34px;font-weight:500;color:var(--lime);line-height:1.35">它有形状。</div>
    <p class="appearup zh-loose" style="font-size:12.5px;color:rgba(255,255,255,.58);margin-top:10px">
      Aira 把睡眠、心率与唾液皮质醇放在一起解读 —— 说清你的身体正处于什么状态，以及哪些还无法断言。</p>
    <div style="flex:1 0 8px;max-height:22px"></div>
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
         ['一份联合解读','你的状态、你的计划，以及仍未知的问题',
          `<span style="width:88px;display:flex;justify-content:center">
            <span style="width:40px;height:40px;border-radius:10px;background:#f4f2ec;display:flex;align-items:center;justify-content:center;transform:rotate(4deg);box-shadow:0 3px 8px rgba(0,0,0,.25)">${ic('plan',22,1.6,'#5d6b2f')}</span></span>`]
       ].map((r,i)=>`<div class="row appearup" style="gap:14px;animation-delay:${0.18+i*0.09}s">${r[2]}
          <div><div style="font-size:13.5px;font-weight:600;color:#fff">${r[0]}</div>
          <div style="font-size:11px;color:rgba(255,255,255,.48);margin-top:2px">${r[1]}</div></div></div>`).join('')}
    </div>
    <div style="margin-top:16px">${cta('开始使用','data-act="getstarted"')}</div>
    <div style="text-align:center;font-size:10.5px;color:rgba(255,255,255,.32);margin-top:10px">Aira 不是医疗器械，仅用于健康生活指导。</div>
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
  const types=[['moon','睡眠分析','时长、分期、觉醒次数'],
    ['pulse','心率变异性','恢复状况的核心信号'],
    ['pulse','静息心率','与 HRV 一起读，从不单看'],
    ['steps','步数与活动','负荷侧的证据'],
    ['breath','呼吸频率','疾病的旁证']];
  const wearables=[['appicon_oura','Oura Ring'],['appicon_whoop','WHOOP'],['appicon_garmin','Garmin']];
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(0,3,'data-act="phase" data-v="welcome"')}
    <h2>连接你的数据</h2>
    <div class="sub">只读权限。Aira 会导入最近 30 天数据，让你的第一份解读一开始就有基线可对比。</div>
    <div class="body">
      <button class="wcard ${S.healthGranted?'on':''}" data-act="grant" style="display:flex;align-items:center;gap:13px;width:100%;padding:15px;text-align:left">
        <img src="Assets/appicon_health.png" style="width:48px;border-radius:12px">
        <div style="flex:1"><div style="font-size:15px;font-weight:600">Apple Health</div>
          <div style="font-size:11.5px;color:${S.healthGranted?'var(--ink2)':'var(--ink3)'};margin-top:2px">
            ${S.healthGranted?'已连接 · 5 类数据':'必须连接 —— 信号的来源'}</div></div>
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
        <span class="zh-loose" style="font-size:11.5px;color:var(--ink3)">没有手表？iPhone 自带的睡眠和步数也可用 —— Aira 只是会在据此得出的每个结论里，标注精度较低。</span></div>
    </div>
    <div class="foot">${cta(S.healthGranted?'导入最近 30 天':'连接 Apple Health','data-act="connectnext"')}</div>
  </div></div>`;
}

/* ---- 3 Syncing ---- */
function vSyncing(){
  const items=['睡眠分析 · 30 天','心率变异性 · 30 天','静息心率 · 30 天','步数与活动 · 30 天'];
  return `<div class="view"><div class="fogscreen warm"></div>
  <div style="position:relative;display:flex;flex-direction:column;align-items:stretch;justify-content:center;height:100%;padding:0 26px;color:#fff">
    ${textSphere(180,52)}
    <div class="serif" style="font-size:21px;font-weight:600;text-align:center;margin-top:18px">正在读取你最近 30 天的数据</div>
    <div class="glass" style="border-radius:22px;padding:18px;margin-top:24px;display:flex;flex-direction:column;gap:12px">
      ${items.map((s,i)=>`<div class="row" style="gap:10px">
        <span id="sync-dot-${i}" style="width:16px;height:16px;border-radius:50%;flex:none;display:flex;align-items:center;justify-content:center;
          ${i<S.syncedItems?'background:var(--lime)':'border:1.4px solid rgba(255,255,255,.2)'}">
          ${i<S.syncedItems?ic('check',9,2.6,'var(--ink)'):''}</span>
        <span id="sync-txt-${i}" style="font-size:13px;color:${i<S.syncedItems?'#fff':'rgba(255,255,255,.35)'}">${s}</span></div>`).join('')}
    </div>
    <div id="syncbar" style="margin:22px 28px 0">${neonBar(S.syncedItems/4*100)}</div>
    <div style="position:absolute;bottom:max(30px, env(safe-area-inset-bottom));left:0;right:0;text-align:center;
         font-size:11px;color:rgba(255,255,255,.34)">数据只在你的设备与 Aira 的加密存储之间流动。</div>
  </div></div>`;
}
function beginSync(){
  S.phase='syncing'; S.syncedItems=0; render();
  let i=0;
  const t=setInterval(()=>{
    i++; S.syncedItems=i;
    for(let k=0;k<4;k++){
      const d=document.getElementById('sync-dot-'+k), x=document.getElementById('sync-txt-'+k);
      if(!d) return;
      if(k<i){ d.style.border='none'; d.style.background='var(--lime)'; d.innerHTML=ic('check',9,2.6,'var(--ink)'); x.style.color='#fff'; }
    }
    const b=document.getElementById('syncbar'); if(b)b.innerHTML=neonBar(i/4*100);
    if(i>=4){ clearInterval(t); setTimeout(()=>{ if(S.phase==='syncing'){S.phase='recap';render();} },520); }
  },620);
}

/* ---- 4 First read (recap) ---- */
function vRecap(){
  const day=Mock.days[12];
  return `<div class="view" style="background:var(--page)">
  <div class="scroll" style="padding:0 20px;padding-top:max(18px, env(safe-area-inset-top))">
    ${sectionLabel('来自已同步数据 · 10月7日 – 13日')}
    <div class="serif" style="font-size:27px;font-weight:600;line-height:1.35;margin-top:8px">数据里已经<br>能看出一些东西了</div>
    <div class="zh-loose" style="font-size:13.5px;color:var(--ink2);margin-top:7px">不用等唾液 —— 最近 7 天的睡眠和心率，已经能说出一部分。</div>
    <div style="display:flex;flex-direction:column;gap:14px;margin-top:14px;padding-bottom:12px">
      ${recoveryCardHTML()}
      ${nightCardHTML(day)}
      <div class="fog warm"><div class="bg"></div><div class="pad">
        ${cardHead('spark','Aira 的第一个判断','设备数据 × 你自己的话')}
        <div style="font-size:19px;font-weight:600;line-height:1.5;margin-top:12px">不是睡少了 —— 是睡碎了。</div>
        <div class="zh-loose" style="font-size:13.5px;color:var(--onD2);margin-top:8px">总时长比基线少 64 分钟，但更关键的是整夜断成 5 段，最长一段只有 2 小时。深睡需要长段连续累积 —— 这正对上你醒来仍然疲惫。</div>
        ${qualifier('我只能说到这里','睡眠和心率只能显示恢复负荷升高了 —— 说不了为什么。夜间照护和工作冲刺落在同一个窗口里，数据分不开它们。')}
      </div></div>
      <div class="fog flat"><div class="bg"></div><div class="pad">
        ${cardHead('drop','唾液能补上什么','三个设备数据答不了的问题')}
        <div style="display:flex;flex-direction:column;gap:13px;margin-top:13px">
        ${[['是「启动不了」，还是单纯没睡够','清晨两个点之间的上升幅度（CAR）能把它们区分开'],
           ['晚上到底有多难「关机」','睡前那一管，是五种状态唯一能分开的点'],
           ['是消耗太多，还是修复太少','DHEA 与睾酮/皮质醇比值，指向完全不同的干预']]
          .map((p,i)=>`<div class="row" style="gap:11px;align-items:flex-start">
            <span style="font-size:10px;font-weight:700;color:var(--lime);width:18px;padding-top:3px">0${i+1}</span>
            <div><div style="font-size:13.5px;font-weight:600;line-height:1.5">${p[0]}</div>
              <div class="zh-loose" style="font-size:12px;color:var(--onD2);margin-top:3px">${p[1]}</div></div></div>`).join('')}
        </div></div></div>
    </div></div>
  <div style="padding:10px 20px max(20px, env(safe-area-inset-bottom))">
    ${cta('继续','data-act="phase" data-v="profile"')}
    <button class="ghost-link" data-act="skiphome">跳过设置，直接进首页</button></div>
  </div>`;
}

/* ---- 5 About you (2 steps) ---- */
function ruler(valKey,val,min,max,unit){
  return `<div class="ruler"><div class="val">${val}<span>${unit}</span></div>
    <input type="range" min="${min}" max="${max}" value="${val}" data-ruler="${valKey}">
    <div class="ends"><span>${min}</span><span>${Math.round((min+max)/2)}</span><span>${max}</span></div></div>`;
}
function vProfile(){
  const step=S.profStep;
  const title=step===0?'先认识一下你':'你平时训练吗？';
  const sub=step===0?'称呼、年龄与出生性别 —— 它们决定你的结果对照哪一组参考区间。'
                    :'训练负荷会改变恢复数据的解读方式 —— 也决定计划敢对你提出多少要求。';
  let body='';
  if(step===0){
    body=`<div style="display:flex;flex-direction:column;gap:20px;padding-top:6px">
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">Aira 该怎么称呼你？</span></div>
        <input id="nick" class="serif" value="${S.nickname.replace(/"/g,'&quot;')}" placeholder="Chloe"
          style="width:100%;background:#fff;border:1px solid var(--hair);border-radius:18px;padding:15px 17px;
                 font-size:21px;font-weight:600"></div>
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">年龄</span>
          <span style="font-size:11px;color:var(--ink3)">参考区间随年龄段变化</span></div>
        ${ruler('age',S.age,13,90,'岁')}</div>
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">出生性别</span>
          <span style="font-size:11px;color:var(--ink3)">皮质醇与 DHEA 的区间不同</span></div>
        <div class="seg">${['女','男','不便透露'].map((o,i)=>
          `<button class="${S.sex===i?'on':''}" data-act="sex" data-v="${i}">${o}</button>`).join('')}</div>
        ${S.sex===2?`<div class="row" style="gap:8px;align-items:flex-start;margin-top:10px">${ic('info',12,1.9,'var(--ink3)','margin-top:3px')}
          <span class="zh-loose" style="font-size:11.5px;color:var(--ink3)">Aira 将使用更宽的合并区间 —— 结论会带稍大的不确定性。</span></div>`:''}
      </div></div>`;
  } else {
    const freqs=[['不练','moon'],['1–2 次','run'],['3–4 次','run'],['5 次以上','run']];
    body=`<div style="display:flex;flex-direction:column;gap:16px;padding-top:10px">
      <div style="font-size:13px;font-weight:600">每周训练几次？</div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:9px">
        ${freqs.map((f,i)=>`<button class="wcard" data-act="band" data-v="${i}"
          style="padding:17px 4px;border-radius:17px;display:flex;flex-direction:column;align-items:center;gap:5px;
          ${S.sessionBand===i?'background:var(--ink);color:#fff;border-color:var(--ink)':''}">
          ${ic(f[1],18,1.9,S.sessionBand===i?'#fff':'var(--ink2)')}
          <span style="font-size:14px;${S.sessionBand===i?'font-weight:600':'font-weight:500'}">${f[0]}</span></button>`).join('')}</div>
      ${S.sessionBand>0?`<div class="fadein"><div style="font-size:13px;font-weight:600;margin:8px 0 10px">练了多久了？</div>
        ${ruler('years',S.years,0,30,'年')}</div>`:''}
    </div>`;
  }
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(1,3, step===0?'data-act="phase" data-v="recap"':'data-act="profstep" data-v="0"')}
    <h2>${title}</h2><div class="sub">${sub}</div>
    <div class="body">${body}</div>
    <div class="foot">${cta(step===0?'继续':'没问题', step===0?'data-act="profstep" data-v="1"':'data-act="phase" data-v="medical"')}</div>
  </div></div>`;
}

/* ---- 6 Health background ---- */
const INJURIES=[['〰','下背部','限制运动侧的负荷上限'],
  ['⌐','膝盖','用低冲击训练替代跑步'],
  ['⌙','肩部','影响过头与推举的容量'],
  ['∟','跟腱','排除爆发式动作与冲刺']];
const MEDS=[['⚗','皮质类固醇','直接抬高测得的皮质醇'],
  ['◑','避孕药 / 激素类','改变所使用的参考区间'],
  ['B7','生物素（维生素 B7）','干扰唾液检测'],
  ['▭','抗抑郁药','可能抹平晨间上升'],
  ['≋','吸入性激素','采样前需要漱口']];
function medGroup(title,rows,set,act){
  return `<div><div class="row" style="margin-bottom:9px"><span style="font-size:14px;font-weight:600">${title}</span>
    ${set.size?`<span style="margin-left:auto;font-size:11px;color:var(--ink3)">已选 ${set.size} 项</span>`:''}</div>
   <div class="rowlist">${rows.map(r=>{
     const on=set.has(r[1]);
     return `<button class="rowitem ${on?'on':''}" data-act="${act}" data-v="${r[1]}">
       <span class="ric" style="font-size:${r[0].length>1?'12px':'17px'};font-weight:700;color:${r[0]==='B7'?'var(--amber)':'var(--ink)'}">${r[0]}</span>
       <span class="rt"><span class="a" style="display:block">${r[1]}</span><span class="b" style="display:block;margin-top:1px">${r[2]}</span></span>
       <span class="box">${on?ic('check',11,2.6,'#fff'):''}</span></button>`;}).join('')}</div></div>`;
}
function vMedical(){
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(2,3,'data-act="phase" data-v="profile"')}
    <h2>有什么需要我们知道的吗？</h2>
    <div class="sub">每一项都会改变结果的解读方式。不适用的直接跳过。</div>
    <div class="body"><div style="display:flex;flex-direction:column;gap:22px">
      ${medGroup('伤病史',INJURIES,S.injuries,'injury')}
      ${medGroup('用药与补剂',MEDS,S.meds,'med')}
      ${S.meds.has(BIOTIN)?`<div class="fadein row" style="gap:11px;align-items:flex-start;padding:14px;
          border-radius:17px;background:rgba(220,245,90,.45)">
        <span style="width:34px;height:34px;border-radius:10px;background:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;color:var(--amber);flex:none">B7</span>
        <div><div style="font-size:13px;font-weight:600">我们会调整你的采样日</div>
          <div class="zh-loose" style="font-size:11.5px;color:var(--ink2);margin-top:3px">首管前需停用生物素 48 小时，否则检测值会偏高。Aira 会自动绕开安排。</div></div></div>`:''}
    </div></div>
    <div class="foot">${cta('继续','data-act="finishonb"')}
      <button class="ghost-link" data-act="noneapply">都不适用</button></div>
  </div></div>`;
}

/* ---- Main shell (Home / Aira / Plan) ---- */
function vMain(){
  let inner='';
  if(S.tab===0) inner=vHome();
  else if(S.tab===1) inner=vAgent();
  else inner='';   // 计划页内容在 #planhost 的 iframe 里（plan.html）
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

/* ---- Home tab ---- */
function vHome(){
  const day=Mock.days[S.dayIndex], isToday=S.dayIndex===Mock.days.length-1, hasData=day.sleep!=='—';
  return `<div class="scroll" style="padding:0 16px 110px;padding-top:max(14px, env(safe-area-inset-top))">
    <div class="shell">
      <div class="row" style="padding:0 4px;gap:12px">
        <div style="flex:1"><div style="font-size:12.5px;color:var(--ink3)">10月14日 周二</div>
          <div style="font-size:21px;font-weight:600;margin-top:3px">早上好，${nick()}</div></div>
        <img src="Assets/avatar.jpg" style="width:48px;height:48px;border-radius:50%;object-fit:cover;
             border:2px solid rgba(255,255,255,.9);box-shadow:0 3px 8px rgba(0,0,0,.25)"></div>
      <div class="fog warm" style="border-radius:24px;margin-top:16px"><div class="bg"></div><div class="pad" style="padding:18px">
        <div class="row" style="align-items:flex-start">
          <div class="cardhead" style="flex:1"><div class="ibadge">${ic('recover',16,1.7,'#fff')}</div>
            <div class="tt"><div class="a" style="font-size:16px;font-weight:500">恢复负荷</div>
              <div class="b">近期 · 7 天窗口</div></div></div>
          <div style="text-align:right"><span class="num" style="font-size:19px">47</span>
            <span style="font-size:11px;color:var(--onD2)"> / 基线</span>
            <div style="font-size:10px;color:var(--onD3)">前 28 天</div></div></div>
        <div class="row" style="align-items:baseline;gap:5px;margin-top:10px">
          <span class="num" style="font-size:42px">${day.rec||60}</span>
          <span style="font-size:15px;color:var(--onD2)">/ 100</span>
          <span style="margin-left:auto;font-size:12.5px;font-weight:600;color:${(day.rec||60)>=58?'var(--coral)':'var(--lime)'}">
            ${(day.rec||60)>=58?'负荷偏高':(day.rec||60)>=45?'轻度积累':'恢复良好'}</span></div>
        <div class="row" style="justify-content:space-between;margin-top:8px;font-size:11px;color:var(--onD3)"><span>0</span><span>100</span></div>
        <div style="margin-top:6px">${comb(34,(day.rec||60)/100,30)}</div>
        <div class="row" style="gap:8px;margin-top:20px;align-items:flex-start">
          ${[[Mock.avgSleepText(7),'','睡眠 · 7天均值'],[Math.round(Mock.avg(7,d=>d.hrv)),'ms','HRV · 7天均值'],
             [Math.round(Mock.avg(7,d=>d.rhr)),'bpm','静息心率 · 7天均值']].map(x=>`<div style="flex:1">
            <span class="num" style="font-size:24px">${x[0]}</span>
            ${x[1]?`<span style="font-size:12px;color:var(--onD2)"> ${x[1]}</span>`:''}
            <div style="font-size:10.5px;color:var(--onD3);margin-top:3px">${x[2]}</div></div>`).join('')}</div>
      </div></div>
      <div class="row" style="gap:5px;margin-top:18px;padding:0 4px">
        ${RANGES.map((r,i)=>`<button data-act="range" data-v="${i}" style="padding:7px 13px;border-radius:99px;font-size:12px;
          ${S.range===i?'background:var(--ink);color:#fff;font-weight:600':'background:var(--hair2);color:var(--ink2)'}">${r.t}</button>`).join('')}
        <span style="margin-left:auto;font-size:10.5px;color:var(--ink3)">${RANGES[S.range].grain}</span></div>
      <div style="margin-top:8px">${sleepScrubber()}</div>
      <div style="margin-top:14px">
        <div class="row" style="padding:0 4px">
          <div style="flex:1"><div style="font-size:13.5px;font-weight:600">你的感受</div>
            <div style="font-size:10.5px;color:var(--ink3);margin-top:1px">${S.loggedToday?`今天已记录 ·「${faceNames[S.feel]}」`:'今天还没打卡'}</div></div>
          <button data-act="sheet" data-v="checkin" style="display:flex;align-items:center;gap:6px;padding:8px 12px;
            border-radius:99px;background:var(--ink);color:#fff;font-size:12px;font-weight:600">
            ${ic(S.loggedToday?'refresh':'plus',12,2.2,'#fff')} ${S.loggedToday?'修改':'打卡'}</button></div>
        <div style="margin-top:2px">${selfTrend()}</div></div>
    </div>
    <div style="display:flex;flex-direction:column;gap:14px;margin-top:14px;padding:0 4px">
      ${hasData?nightCardHTML(day):`<div class="fog flat"><div class="bg"></div><div class="pad">
        ${cardHead('info','该日无数据',`${day.date} · ${day.wd}`,'已剔除','off')}
        <div style="font-size:14px;margin-top:13px">没戴手表，或没有同步。</div>
        <div class="zh-loose" style="font-size:12.5px;color:var(--onD2);margin-top:6px">已从 7 天均值中剔除 —— 所以「7 天均值」实际基于 6 天。</div></div></div>`}
      ${isToday&&hasData?`<div class="fog warm"><div class="bg"></div><div class="pad">
        ${cardHead('clock','昨天','活动 × 精力 · 10/13','午后低谷','warn')}
        <div style="font-size:15px;font-weight:600;line-height:1.6;margin-top:12px">昨天的久坐时段，<br>正好压在你的精力低点上。</div>
        <div style="margin-top:8px">${dayRibbon()}</div>
        ${statTrio([{v:'8,260',k:'步数'},{v:'13:10',k:'开始久坐'},{v:'自评 2 分',k:'14:00 的精力'}])}</div></div>`:''}
      <button data-act="sheet" data-v="testing" style="text-align:left;width:100%">
        <div class="fog flat"><div class="bg"></div><div class="pad">
          ${cardHead('drop',salivaTitle(),'第一次唾液检测', S.saliva===2?donePts()+'/5':null, 'good',
             `<span style="color:var(--onD3)">${ic('chevron',13,2,'currentColor')}</span>`)}
          <div class="zh-loose" style="font-size:13px;color:var(--onD2);margin-top:11px">${salivaSub()}</div>
          ${S.saliva===2||S.saliva===3?`<div style="margin-top:12px">${comb(5,donePts()/5,18)}</div>`:''}
        </div></div></button>
    </div></div>`;
}
function salivaTitle(){
  return ['唾液检测 · 未安排','唾液检测 · 明早开始','唾液检测 · 采集中','已寄出 · 实验室处理中','唾液报告已出'][S.saliva];
}
function salivaSub(){
  return ['我们仍说不清恢复负荷为什么升高。唾液皮质醇能区分：是 HPA 轴的问题，还是单纯欠睡。',
    '醒后 30 分钟内取第一管。今晚开始停用生物素补剂。',
    `下一管 ${(S.points.find(p=>!p.done)||{}).when||''} · ${(S.points.find(p=>!p.done)||{}).name||''}`,
    '结果通常需要 5–7 个工作日，之后 Aira 会把它和这几周的睡眠放在一起解读。',
    'HPA 轴：透支。早上启动不了，晚上关不掉。'][S.saliva];
}

/* ---- Agent tab ---- */
function vAgent(){
  const stageLine=['追踪中 · 恢复负荷 7 天','追踪中 · 明天开始采集',
    `追踪中 · 已采 ${donePts()}/5`,'追踪中 · 等待实验室','追踪中 · 报告与计划'][S.saliva];
  const thread=buildThread();
  const primary = S.saliva===0 ? (S.sent.includes('安排在明天')?null:'安排在明天')
                : S.saliva===4 ? (S.sent.includes('打开完整报告')?null:'打开完整报告') : null;
  const ctxAll = S.saliva===0?['为什么是唾液？','我的睡眠哪里有问题？','带我看首页']
    : S.saliva<=2?['采样日要避免什么？','错过时间点怎么办？','进度如何？']
    : S.saliva===3?['要等多久？','等待期间我能做什么？']
    : ['「透支」是什么意思？','为什么是这三件事？'];
  const ctx=ctxAll.filter(c=>!S.sent.includes(c));
  return `<div style="display:flex;flex-direction:column;height:100%;color:#fff">
    <div style="text-align:center;padding-top:max(14px, env(safe-area-inset-top));position:relative;flex:none">
      <div style="width:46px;height:46px;border-radius:50%;background:rgba(255,255,255,.10);
        border:1px solid rgba(255,255,255,.18);margin:6px auto 0;display:flex;align-items:center;justify-content:center;position:relative">
        <span style="position:absolute;top:-4px;right:-4px;width:16px;height:16px;border-radius:50%;background:var(--lime);filter:blur(7px)"></span>
        ${ic('spark',20,1.9,'var(--lime)')}</div>
      <div class="row" style="justify-content:center;gap:4px;margin-top:5px">
        <span style="font-size:13.5px;font-weight:600">Aira</span>${ic('chevron',9,2.2,'rgba(255,255,255,.4)')}</div>
      <div style="font-size:10.5px;color:rgba(255,255,255,.42);margin-top:2px">${stageLine}</div>
      <button data-act="sheet" data-v="testing" style="position:absolute;right:16px;top:max(22px, env(safe-area-inset-top));
        width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.10);display:flex;align-items:center;justify-content:center">
        ${ic('drop',16,1.9,'rgba(255,255,255,.8)')}</button></div>
    <div style="display:flex;gap:7px;overflow-x:auto;scrollbar-width:none;padding:10px 16px;flex:none">
      ${ctxChip('recover','恢复','60 · 偏高',true)}
      ${ctxChip('moon','睡眠','6:31 ↓64分',true)}
      ${ctxChip('pulse','HRV','42 ms',false)}
      ${S.saliva===4?ctxChip('drop','HPA','透支',true):ctxChip('drop','唾液',['未安排','明天','已采 '+donePts()+'/5','实验室中','已出'][S.saliva],false)}
    </div>
    <div id="threadscroll" class="scroll" style="padding:4px 14px 10px">
      ${thread}
    </div>
    <div style="flex:none;padding:8px 0 90px">
      ${(primary||ctx.length)?`<div style="display:flex;gap:7px;overflow-x:auto;scrollbar-width:none;padding:0 16px 8px">
        ${primary?`<button class="replychip" data-act="send" data-v="${primary}" style="background:var(--lime);color:var(--ink);font-weight:600;flex:none">
          ${ic('spark',11,2.2,'var(--ink)')} ${primary}</button>`:''}
        ${ctx.map(c=>`<button class="replychip glass" data-act="send" data-v="${c}" style="flex:none;font-size:12.5px">${c}</button>`).join('')}
      </div>`:''}
      <div class="row" style="gap:10px;padding:0 16px">
        <button data-act="sheet" data-v="checkin" style="width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.10);
          display:flex;align-items:center;justify-content:center;flex:none">${ic('plus',17,2,'rgba(255,255,255,.75)')}</button>
        <div class="row" style="flex:1;gap:8px;padding:5px 5px 5px 15px;border-radius:99px;background:rgba(255,255,255,.09);
             border:1px solid rgba(255,255,255,.13)">
          <input id="composer" placeholder="发消息" style="flex:1;color:#fff;font-size:15px;min-width:0">
          <button data-act="composer" style="width:28px;height:28px;border-radius:50%;background:rgba(255,255,255,.10);
            display:flex;align-items:center;justify-content:center;flex:none">${ic('arrowUp',14,2.4,'rgba(255,255,255,.3)')}</button>
        </div></div></div>
  </div>`;
}
function ctxChip(icon,label,value,warn){
  return `<span class="ctxchip glass">${ic(icon,12,2,warn?'var(--amber)':'var(--lime)')}
    <span>${label}</span><b>${value}</b></span>`;
}
function bub(t,lead=false,grouped=false){
  return `<div class="bubble glass ${lead?'lead':''}" style="border-radius:${grouped?'19px 19px 19px 5px':'19px'};margin-top:${grouped?'3px':'14px'}">${t}</div>`;
}
function userBub(t){ return `<div class="bubble user" style="margin-top:14px">${t}</div>`; }
function buildThread(){
  let out=`<div class="stagemark" style="margin-top:8px">10月14日 周二</div>`;
  out+=bub('你的数据进来了。我看了最近 7 天。');
  out+=`<div style="margin:10px 28px 0 2px">${nightCardHTML(Mock.days[12],true)}</div>`;
  out+=bub('不是睡少了 —— 是睡碎了。',true);
  out+=bub('总时长比基线少 64 分钟，但整夜断成 5 段，最长一段只有 2 小时。深睡需要长段连续累积 —— 这正对上你醒来仍然疲惫。',false,true);
  if(S.saliva===0){
    out+=`<div style="margin-right:34px">${qualifier('我只能说到这里','睡眠和心率只能显示恢复负荷升高了 —— 说不了为什么。夜间照护和工作冲刺落在同一个窗口里，数据分不开它们。')}</div>`;
    out+=bub('唾液皮质醇能把它们分开 —— 晨间上升会告诉我们：这是 HPA 轴本身的问题，还是单纯的睡眠欠债。');
  }
  for(const s of S.sent) out+=exchange(s);
  if(S.saliva>=1&&S.saliva<4){
    out+=`<div class="stagemark" style="margin-top:18px">采集</div>`;
    if(S.saliva===1){
      out+=bub('已安排在明天。醒后 30 分钟内取第一管 —— 我会在你平时的起床时间提醒你。');
      out+=bub('今晚开始停用生物素（维生素 B7）补剂 —— 它会干扰检测。',false,true);
    } else if(S.saliva===2){
      const nx=S.points.find(p=>!p.done);
      out+=bub(`已完成 ${donePts()} 管。下一管：${nx?nx.name:''}，${nx?nx.when:''}。`);
    } else {
      out+=bub('五管全部收齐并寄出了。结果通常需要 5–7 个工作日。');
      out+=bub('等待期间我会继续盯着你的睡眠。如果入睡点稳定下来，我们就能分清哪些变化来自干预本身。',false,true);
    }
  }
  if(S.saliva===4){
    out+=`<div class="stagemark" style="margin-top:18px">报告</div>`;
    if(!S.sent.includes('打开完整报告')){
      out+=`<div class="glass" style="border-radius:24px;padding:18px 10px;margin-top:10px;text-align:center">
        ${textSphere(150,40)}
        <div class="shiny" style="font-size:12.5px;margin-top:10px">正在把你的唾液结果与 30 天可穿戴数据做联合分析</div>
        <div style="margin:12px 28px 0">${neonBar(62)}</div></div>`;
    }
    out+=bub('报告出来了。');
    out+=bub('你的状态是「透支」—— 该启动时启动不了，该停下时停不下来。',true,true);
    out+=`<button data-act="sheet" data-v="report" style="display:block;width:calc(100% - 28px);margin:10px 28px 0 0;text-align:left">
      <div class="glass" style="border-radius:22px;padding:16px;color:#fff">
        <div class="cardhead"><div class="ibadge">${ic('breath',16,1.7,'#fff')}</div>
          <div class="tt"><div class="a">HPA 轴</div><div class="b">唾液 · 10/15</div></div>
          ${chipEl('调节变慢','warn')}</div>
        <div class="row" style="gap:7px;align-items:baseline;margin-top:11px">
          <span style="font-size:24px;font-weight:600;color:var(--amber)">紧绷</span>
          <span style="font-size:12.5px;color:rgba(255,255,255,.55)">透支</span></div>
        <div style="margin-top:8px">${hpaDeviation(300,120)}</div>
        <div class="hair-d" style="margin:12px 0"></div>${stateStrip(3)}</div></button>`;
    out+=bub('该出现的晨间上升没有出现（CAR 32%，预期 >50%），下午和晚上也始终没降下来（AUCg 33.3，平衡值 22.0）。两端都和你说的对得上。');
    out+=`<div style="margin-right:34px">${qualifier('只有一天','只采了一天。单日数据上「平衡」与「透支」会重叠 —— 补采「醒后 +30 分钟」和「睡前」两个点来确认。')}</div>`;
    out+=bub('我起草了三条行动，按影响力排序。第一条同时作用于两端。');
    out+=`<div class="glass" style="border-radius:22px;padding:15px;margin:10px 28px 0 0;color:#fff">
      <div class="cardhead"><div class="ibadge">${ic('plan',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">已起草 3 条行动</div><div class="b">到「计划」里滑动卡片，接受或跳过</div></div></div>
      <div style="display:flex;flex-direction:column;gap:7px;margin-top:11px">
        ${S.reportRecs.map(r=>`<div class="row" style="gap:9px;padding:8px 11px;border-radius:11px;background:rgba(255,255,255,.07)">
          <span class="num" style="font-size:12px;width:26px;color:${r.col}">${r.impact}</span>
          <span style="font-size:12.5px;font-weight:500;color:rgba(255,255,255,.88);flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.title}</span>
          ${r.state===1?ic('check',11,2.6,'var(--lime)'):''}</div>`).join('')}</div>
      <button data-act="tab" data-v="2" style="display:flex;align-items:center;justify-content:center;gap:7px;width:100%;
        margin-top:12px;padding:11px;border-radius:99px;background:var(--lime);color:var(--ink);font-size:12.5px;font-weight:600">
        去计划里处理 ${ic('arrowRight',12,2.2,'var(--ink)')}</button></div>`;
  }
  return out;
}
function exchange(s){
  let out=userBub(s);
  const A={
    '安排在明天':['好了。明天 06:45 第一管 —— 我会提醒你。分步指引就在「采集」里。'],
    '为什么是唾液？':['唾液是测量游离皮质醇唯一方便的途径 —— 血液里的大部分皮质醇被蛋白结合着，反映不了当下的调节状态。而且唾液一天能采 5 次，血液做不到。',
      '皮质醇有很强的昼夜节律 —— 同一个人早晚能差 10 倍。单次读数说明不了什么，一整天的形状才说明问题。'],
    '我的睡眠哪里有问题？':['时长少了 64 分钟，但碎片化更关键：3 次觉醒共 42 分钟，而你的基线是 1.2 次、13 分钟。最长连续段只有 2 小时 —— 深睡累积不起来。'],
    '带我看首页':['好。首页按天组织 —— 你可以往回拖着看这一周。'],
    '采样日要避免什么？':['三件事：采样前 30 分钟不进食不喝咖啡，前 10 分钟不刷牙，醒来后先别运动。时间点比精确更重要 —— 前后 15 分钟内都有效。'],
    '错过时间点怎么办？':['在标签上写实际时刻，不要写计划时刻。我按真实时间计算 CAR —— 标错了反而没法比。'],
    '进度如何？':[`已完成 ${donePts()}/5。下一管 ${(S.points.find(p=>!p.done)||{}).when||'—'}。`],
    '要等多久？':['5–7 个工作日。结果一到我马上告诉你。'],
    '等待期间我能做什么？':['先固定起床时间。它不依赖唾液结果，而且等报告落地后，也方便我们归因哪些变化来自干预。'],
    '「透支」是什么意思？':['该启动时启动不了，该停下时停不下来。早晨那端意味着身体没有进入就绪状态；夜晚那端意味着持续警觉 —— 这会让入睡更难。'],
    '为什么是这三件事？':['固定起床时间权重最高（9.1），而且是唯一同时作用于两端的 —— 定住起床时间，入睡点会自己前移。另外两条分别针对夜晚那端和午后低谷。',
      '这一轮不给补剂建议 —— 现有数据还撑不起那个判断。'],
    '打开完整报告':['打开了。第三章整章都在讲这一轮还无法断言的事。'],
  };
  const rs=A[s]||['这需要你还没同步的数据。我手上有睡眠、HRV、静息心率和活动 —— 这些可以聊得很深。激素和代谢的问题，我更想等唾液结果。'];
  rs.forEach((r,i)=>out+=bub(r,false,i>0));
  return out;
}
function send(s){
  if(S.sent.includes(s)) return;
  S.sent.push(s); S.unread=0;
  if(s==='安排在明天'&&S.saliva<1) S.saliva=1;
  if(s==='打开完整报告'){ render(); openSheet('report'); return; }
  if(s==='带我看首页'){ S.tab=0; }
  render();
}

/* ---- Plan tab ---- */
function vPlan(){
  const hasReport=S.saliva===4;
  const dims=[['睡眠',true],['HRV',true],['静息心率',true],['活动',true],['皮质醇',hasReport],['DHEA',hasReport]];
  const accAll=accepted();
  const LIBW=[['walk','快走','低强度 · 最合适','#E9F4C6'],['run','跑步','中高强度','#F7DFE4'],
    ['bike','骑行','中等强度','#DCE7F3'],['strength','力量','高负荷','#F2EADA'],
    ['swim','游泳','全身 · 低冲击','#DCEFE5'],['rope','跳绳','高强度 · 短时','#E8E3F4']];
  const LIBR=[['meditate','呼吸练习','睡前 · 最合适','#E9F4C6'],['stretch','拉伸','久坐之后','#DCEFE5'],
    ['walk','散步','下午','#DCE7F3'],['coffee','咖啡','14:00 之前','#F2EADA'],
    ['dance','跳舞','动起来就好','#F7DFE4'],['read','阅读','代替刷手机','#E8E3F4']];
  const lib=S.planSeg===0?LIBW:LIBR;
  return `<div class="scroll" style="padding:0 20px 110px;padding-top:max(14px, env(safe-area-inset-top))">
    <div class="row" style="align-items:flex-start;padding-top:14px">
      <div style="flex:1"><div style="font-size:12.5px;color:var(--ink3)">${hasReport?'唾液生物标志物 × 设备数据':'来自最近 7 天的设备数据'}</div>
        <div style="font-size:23px;font-weight:600;margin-top:3px">你的计划</div></div>
      <img src="Assets/avatar.jpg" style="width:40px;height:40px;border-radius:50%;object-fit:cover;border:2px solid #fff;box-shadow:0 3px 8px rgba(0,0,0,.2)"></div>
    <div style="margin-top:15px;padding:13px;border-radius:18px;background:rgba(243,243,241,.7)">
      <div class="row"><span style="font-size:9.5px;font-weight:700;letter-spacing:2px;color:var(--ink3)">AIRA 现在看得见</span>
        <span style="margin-left:auto;font-size:10.5px;font-weight:600;color:${hasReport?'var(--ink)':'var(--ink2)'}">${dims.filter(d=>d[1]).length} / 6 个信号</span></div>
      <div class="row" style="gap:5px;margin-top:10px">
        ${dims.map(d=>`<span style="flex:1;display:flex;align-items:center;justify-content:center;gap:4px;padding:5px 2px;
          border-radius:99px;background:${d[1]?'#fff':'var(--hair2)'};${d[1]?'border:1px solid var(--hair)':''};
          font-size:9.5px;color:${d[1]?'var(--ink)':'var(--ink3)'};${d[1]?'font-weight:600':''};white-space:nowrap">
          ${d[1]?'<span style="width:5px;height:5px;border-radius:50%;background:var(--lime)"></span>':ic('lock',8,2.2,'var(--ink3)')}${d[0]}</span>`).join('')}</div>
      <div class="zh-loose" style="font-size:10.5px;color:var(--ink3);margin-top:10px">
        ${hasReport?'唾液结果 10/21 已返回 —— 下面的建议已带上生物标志物证据。':'目前只基于设备数据。唾液会补上两个激素信号 —— 以及更锋利的建议。'}</div></div>
    <div style="margin-top:15px">
      ${hasReport?`<div class="fog cool"><div class="bg"></div><div class="pad">
        ${cardHead('breath','本轮目标','来自报告 · 第 01 章','紧绷','warn')}
        <div style="font-size:17px;font-weight:600;line-height:1.5;margin-top:11px">从「晚上关不掉」这一端开始。</div>
        <div class="zh-loose" style="font-size:13px;color:var(--onD2);margin-top:7px">这一端更容易撬动 —— 固定起床时间会把入睡点往前拉，早晨那端通常随之好转。反过来几乎不成立。</div>
      </div></div>`
      :`<div class="fog flat"><div class="bg"></div><div class="pad">
        ${cardHead('clock','完整计划等唾液结果','有几件事无论如何都值得做','检测进行中','off')}
        <div class="zh-loose" style="font-size:13px;color:var(--onD2);margin-top:12px">唾液结果回来之前，我分不清早晨和夜晚哪一端更要紧 —— 而两者的干预完全不同。下面这些建议只依赖你已有的设备数据。</div>
        <button data-act="sheet" data-v="testing" class="row" style="gap:7px;margin-top:12px;color:var(--lime);font-size:12px;font-weight:600">
          安排采集 ${ic('arrowRight',12,2,'var(--lime)')}</button></div></div>`}</div>
    <div class="row" style="margin-top:15px">
      ${sectionLabel(hasReport?'按影响力排序 · 来自报告':'今天适合你 · 来自设备数据')}
      ${deck().length?`<span style="margin-left:auto;font-size:10.5px;font-weight:600;color:var(--ink3)">待处理 ${deck().length} 条</span>`:''}</div>
    <div style="margin-top:8px">${deckHTML()}</div>
    ${accAll.length||S.arranged.length?`<div style="margin-top:18px">${sectionLabel(`已在计划中 · ${accAll.length+S.arranged.length} 项`)}
      <div style="display:flex;flex-direction:column;gap:9px;margin-top:9px">
      ${accAll.map((r,i)=>`<div class="row" style="gap:12px;padding:13px;border-radius:20px;background:#fff;border:1px solid var(--hair)">
        <span style="width:44px;height:44px;border-radius:13px;background:${r.col.replace('var(--sky)','rgba(122,203,255,.3)').replace('var(--lime)','rgba(220,245,90,.4)').replace('var(--amber)','rgba(255,184,92,.3)').replace('var(--violet)','rgba(183,155,255,.3)')};
          display:flex;align-items:center;justify-content:center;flex:none">${ic(r.saliva?'drop':'spark',18,2,'var(--ink)')}</span>
        <div style="flex:1;min-width:0"><div style="font-size:14.5px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.title}</div>
          <div style="font-size:11px;color:var(--ink3);margin-top:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.constraint}</div></div>
        <span style="display:flex;gap:3px">${[...Array(7)].map((_,k)=>`<i style="width:4px;height:16px;border-radius:99px;background:${k<r.done?'var(--ink)':'var(--hair)'}"></i>`).join('')}</span></div>`).join('')}
      ${S.arranged.map(a=>`<div class="row" style="gap:13px;padding:13px;border-radius:20px;background:#fff;border:1px solid var(--hair)">
        <span style="width:50px;height:50px;border-radius:14px;background:${a.tint};display:flex;align-items:center;justify-content:center;flex:none">${ic(a.icon,24,1.7,'rgba(16,16,17,.8)')}</span>
        <div style="flex:1"><div style="font-size:15px;font-weight:600">${a.name}</div>
          <div style="font-size:11.5px;color:var(--ink3);margin-top:2px">${a.time} · ${a.minutes} 分钟</div></div>
        <span style="display:flex;gap:3px">${[...Array(7)].map((_,k)=>`<i style="width:4px;height:16px;border-radius:99px;background:${k<a.done?'var(--ink)':'var(--hair)'}"></i>`).join('')}</span></div>`).join('')}
      </div></div>`:''}
    <div style="margin-top:18px">${sectionLabel('自己安排')}</div>
    <div class="row" style="gap:6px;margin-top:9px">
      ${['训练','放松'].map((s,i)=>`<button data-act="planseg" data-v="${i}" class="row" style="gap:6px;padding:10px 15px;border-radius:99px;
        ${S.planSeg===i?'background:var(--ink);color:#fff;font-weight:600':'background:#fff;border:1px solid var(--hair);color:var(--ink2)'};font-size:13px">
        ${ic(i===0?'run':'meditate',15,1.9,S.planSeg===i?'#fff':'var(--ink2)')} ${s}</button>`).join('')}</div>
    ${S.planSeg===0?`<div class="row" style="gap:9px;align-items:flex-start;margin-top:12px;padding:13px;border-radius:15px;background:rgba(220,245,90,.4)">
      ${ic('spark',13,2,'var(--ink)','margin-top:2px')}<span class="zh-loose" style="font-size:12.5px;color:var(--ink2)">恢复负荷目前偏高。这周不要加强度 —— 两个低强度选项更合适。</span></div>`:''}
    <div style="display:flex;gap:11px;overflow-x:auto;scrollbar-width:none;margin:12px -20px 0;padding:0 20px 4px">
      ${lib.map(a=>{ const sel=S.arranged.some(x=>x.name===a[1]);
        return `<button class="acttile ${sel?'sel':''}" data-act="arrange" data-v="${a[1]}" data-icon="${a[0]}" data-sub="${a[2]}" data-tint="${a[3]}"
          style="background:${a[3]}"><span class="ai">${ic(a[0],26,1.6,'rgba(16,16,17,.8)')}</span>
          <span><span class="at" style="display:block">${a[1]}</span><span class="as" style="display:block;margin-top:2px">${a[2]}</span></span></button>`;}).join('')}</div>
    ${hasReport?`<div class="fog flat" style="margin-top:14px"><div class="bg"></div><div class="pad">
      <div style="font-size:10.5px;font-weight:600;letter-spacing:2px;color:var(--onD3)">本轮不做</div>
      <div style="display:flex;flex-direction:column;gap:11px;margin-top:11px">
      ${['补剂 —— 现有数据撑不起这个判断','加大强度 —— 恢复负荷已经偏高',
         '咖啡因 —— 采样时未核实，下一轮再说'].map(s=>`<div class="row" style="gap:8px;align-items:flex-start">
         ${ic('minus',11,2,'var(--onD3)','margin-top:4px')}<span class="zh-loose" style="font-size:12.5px;color:var(--onD2)">${s}</span></div>`).join('')}
      </div></div></div>`:''}
    <button data-act="sheet" data-v="ask" class="row" style="gap:9px;width:100%;margin-top:14px;padding:15px 16px;
      border-radius:18px;background:#fff;border:1px solid var(--hair);text-align:left">
      ${ic('ask',15,2,'var(--ink)')}<span style="flex:1;font-size:14px;font-weight:500">问问这份计划</span>
      ${ic('chevron',12,2,'var(--ink3)')}</button>
  </div>`;
}
function deckHTML(){
  const d=deck();
  if(!d.length){
    return `<div style="text-align:center;padding:26px;border-radius:22px;background:#fff;border:1px solid var(--hair)">
      <span style="width:44px;height:44px;border-radius:50%;background:rgba(220,245,90,.5);display:inline-flex;align-items:center;justify-content:center">${ic('check',18,2.4,'var(--ink)')}</span>
      <div style="font-size:14.5px;font-weight:600;margin-top:10px">全部处理完</div>
      <div style="font-size:11.5px;color:var(--ink3);margin-top:3px">${accepted().length} 条已进计划${stage().filter(r=>r.state===2).length?` · ${stage().filter(r=>r.state===2).length} 条已跳过`:''}</div>
      ${stage().filter(r=>r.state===2).length?`<button data-act="restoreskipped" style="margin-top:10px;font-size:12px;font-weight:600;
        padding:8px 14px;border-radius:99px;background:#fff;border:1px solid var(--hair)">回看跳过的</button>`:''}</div>`;
  }
  const under=d.slice(1,3).map((r,i)=>`<div style="position:absolute;inset:0;transform:rotate(${i===0?2.4:-2}deg) translate(${i===0?7:-8}px, ${(i+1)*9}px);
      opacity:${1-(i+1)*0.16};z-index:${2-i};pointer-events:none">${recCard(r,false)}</div>`).join('');
  return `<div class="deckwrap" style="padding-bottom:${Math.min(d.length-1,2)*10+4}px">
    <div style="position:relative">
      ${under}
      <div id="topcard" class="deckcard" style="position:relative;z-index:3">${recCard(d[0],S.deckExpanded)}
        <div id="swipehints" style="position:absolute;inset:0;display:flex;align-items:center;justify-content:space-between;
             padding:0 12px;pointer-events:none;opacity:0;transition:opacity .15s">
          <span style="padding:7px 10px;border-radius:99px;background:rgba(0,0,0,.45);color:#fff;font-size:11px;font-weight:700">‹ 跳过</span>
          <span style="padding:7px 10px;border-radius:99px;background:var(--lime);color:var(--ink);font-size:11px;font-weight:700">收进计划 ›</span>
        </div></div></div>
    <div class="deck-dots">${stage().map(r=>`<i class="${r.state===1?'acc':r.state===2?'skp':''}"></i>`).join('')}</div>
    <div style="text-align:center;font-size:10px;color:var(--ink3);margin-top:8px">向右拖 → 收进计划 · 向左拖 ← 跳过 · 点「为什么」看证据</div></div>`;
}
function recCard(r,expanded){
  return `<div class="fog ${r.saliva?'cool':'flat'}" style="border-radius:22px"><div class="bg"></div><div class="pad" style="padding:18px">
    <div class="row" style="gap:10px;align-items:flex-start">
      ${r.impact?`<div style="width:44px;text-align:center"><div class="num" style="font-size:20px;color:${r.col}">${r.impact}</div>
        <div style="font-size:8px;font-weight:700;letter-spacing:1.5px;color:var(--onD3);margin-top:1px">影响力</div></div>`:''}
      <div style="flex:1"><div class="row" style="gap:6px">
          <span style="font-size:9.5px;font-weight:700;letter-spacing:1.5px;padding:3px 8px;
            border-radius:99px;background:${r.col};color:var(--ink)">${r.tag}</span>
          ${r.saliva?`<span class="row" style="gap:3px">${ic('drop',9,2.2,'var(--lime)')}<span style="font-size:8.5px;font-weight:700;letter-spacing:1px;color:var(--lime)">生物标志物</span></span>`:''}</div>
        <div style="font-size:17px;font-weight:600;line-height:1.45;margin-top:6px">${r.title}</div></div></div>
    <div class="row" style="gap:8px;align-items:flex-start;margin-top:12px">
      ${ic('spark',12,2,'var(--lime)','margin-top:3px')}
      <span class="zh-loose" style="font-size:12.5px;color:var(--onD2);${expanded?'':'display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden'}">${r.because}</span></div>
    ${expanded?`<div class="fadein" style="margin-top:12px"><div class="hair-d"></div>
      <div style="font-size:9px;font-weight:700;letter-spacing:2px;color:var(--onD3);margin-top:10px">依据</div>
      <div class="row" style="gap:6px;flex-wrap:wrap;margin-top:8px">${r.evidence.map(e=>`<span class="evchip"><span class="d"></span>${e}</span>`).join('')}</div>
      <div class="row" style="gap:7px;margin-top:10px">${ic('clock',11,2,'var(--onD3)')}
        <span style="font-size:11px;color:var(--onD2)">${r.timeline}</span></div></div>`:''}
    <div class="row" style="margin-top:9px">
      <span style="font-size:10.5px;color:var(--onD3);flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.constraint}</span>
      <button data-act="deckexpand" class="row" style="gap:4px;color:var(--lime);font-size:10.5px;font-weight:600;padding:4px 0 4px 10px">
        ${expanded?'收起':'为什么'} ${ic('chevron',8,2.4,'var(--lime)',`transform:rotate(${expanded?'-90deg':'90deg'})`)}</button></div>
  </div></div>`;
}

/* ================= Sheets ================= */
function openSheet(kind,arg=null){
  S.sheet=kind; S.sheetArg=arg;
  $sheet.innerHTML=sheetHTML(kind);
  $veil.classList.add('open');
  requestAnimationFrame(()=>requestAnimationFrame(()=>$sheet.classList.add('open')));
  wireSheet();
}
function closeSheet(cb){
  $sheet.classList.remove('open'); $veil.classList.remove('open');
  const k=S.sheet; S.sheet=null;
  setTimeout(()=>{ $sheet.innerHTML=''; if(cb)cb(k); },420);
}
function refreshSheet(){ if(S.sheet){ $sheet.innerHTML=sheetHTML(S.sheet); wireSheet(); } }
function sheetHTML(kind){
  if(kind==='testing') return shTesting();
  if(kind==='guidance') return shGuidance();
  if(kind==='report') return shReport();
  if(kind==='checkin') return shCheckin();
  if(kind==='ask') return shAsk();
  if(kind==='arrange') return shArrange();
  return '';
}
function sheetHead(title){
  return `<div class="grab"></div><div class="row" style="padding:16px 20px 4px">
    <span style="font-size:18px;font-weight:600;flex:1">${title}</span>
    <button data-act="closesheet" style="width:32px;height:32px;border-radius:50%;background:var(--hair2);
      display:flex;align-items:center;justify-content:center">${ic('close',12,2.3,'var(--ink2)')}</button></div>`;
}

/* -- Testing (saliva collection) -- */
function shTesting(){
  const status=['未安排','已安排 · 明天早上',`采集中 · ${donePts()} / 5`,'已寄出 · 实验室处理中','报告已出'][S.saliva];
  let body='';
  if(S.saliva===0){
    body=`<div class="fog cool"><div class="bg"></div><div class="pad">
      ${cardHead('drop','五管，一天','在家完成 · 寄回实验室','约 15 分钟','sky')}
      <div style="font-size:17px;font-weight:600;margin-top:14px">为什么是五个时间点</div>
      <div class="zh-loose" style="font-size:13px;color:var(--onD2);margin-top:6px">同一个人一天内的皮质醇可以相差 10 倍。形状本身，就是测量结果。</div>
      <div style="margin-top:10px">${fiveTubesCurve()}</div></div></div>
    <div class="fog flat"><div class="bg"></div><div class="pad">
      ${cardHead('info','采样日注意避开','四件事 —— 都会让检测失真')}
      <div style="display:flex;flex-direction:column;gap:11px;margin-top:12px">
      ${['前 24 小时停用生物素（维生素 B7）','前 30 分钟不进食、不喝咖啡',
         '前 10 分钟不刷牙 —— 牙龈出血会污染样本',
         '醒来后先别运动 —— 第一管在醒后 30 分钟内'].map(s=>`<div class="row" style="gap:10px;align-items:flex-start">
        <span style="width:18px;height:18px;border-radius:50%;background:rgba(255,138,91,.16);display:flex;align-items:center;justify-content:center;flex:none;margin-top:2px">${ic('close',9,2.4,'var(--coral)')}</span>
        <span class="zh-loose" style="font-size:13px;color:var(--onD2)">${s}</span></div>`).join('')}</div></div></div>
    ${cta('安排在明天','data-act="schedule"')}`;
  } else if(S.saliva===1||S.saliva===2){
    body=`<div class="fog warm"><div class="bg"></div><div class="pad">
      ${cardHead('drop','今天的五管','10月15日',`${donePts()} / 5`,'good')}
      <div style="margin-top:14px">${comb(5,donePts()/5,22)}</div>
      <div style="font-size:11px;color:var(--onD3);margin-top:8px">在每个时间点采样 —— 前后 15 分钟内都有效。</div></div></div>
    <div style="display:flex;flex-direction:column;gap:9px">
    ${S.points.map((p,i)=>`<button data-act="point" data-v="${i}" class="row" style="gap:12px;padding:14px;border-radius:17px;
        background:#fff;border:1px solid ${p.done?'rgba(220,245,90,.9)':'var(--hair)'};text-align:left;width:100%">
      <span style="width:42px;height:42px;border-radius:50%;background:${p.done?'var(--lime)':'var(--hair2)'};
        display:flex;align-items:center;justify-content:center;flex:none">
        ${p.done?ic('check',14,2.4,'var(--ink)'):`<span class="num" style="font-size:9.5px;color:var(--ink2)">${p.when}</span>`}</span>
      <span style="flex:1"><span style="display:block;font-size:14px;font-weight:600">${p.name}</span>
        <span style="display:block;font-size:11.5px;color:var(--ink3);margin-top:2px">${p.hint}</span></span>
      ${p.done?'<span style="font-size:11.5px;color:var(--ink3)">完成</span>':ic('chevron',12,2.2,'var(--ink3)')}</button>`).join('')}</div>
    <button class="ghost-link" data-act="fastforward">演示：直接跳到报告</button>`;
  } else if(S.saliva===3){
    body=`<div class="fog flat"><div class="bg"></div><div class="pad">
      ${cardHead('plan','已寄出','10/15 · 18:20','处理中','off')}
      <div style="display:flex;flex-direction:column;gap:12px;margin-top:14px">
      ${[['五管全部采集完成',1],['已寄出',1],['实验室处理中',0],['报告生成',0]].map(s=>`<div class="row" style="gap:10px">
        <span style="width:16px;height:16px;border-radius:50%;${s[1]?'background:var(--lime)':'border:1.4px solid rgba(255,255,255,.2)'};
          display:flex;align-items:center;justify-content:center;flex:none">${s[1]?ic('check',9,2.6,'var(--ink)'):''}</span>
        <span style="font-size:13px;color:${s[1]?'#fff':'var(--onD3)'}">${s[0]}</span></div>`).join('')}</div>
      <div class="zh-loose" style="font-size:12px;color:var(--onD2);margin-top:14px">结果通常 5–7 个工作日送达。Aira 会把它和这几周的睡眠放在一起解读。</div></div></div>
    ${cta('演示：报告已出','data-act="fastforward"')}`;
  } else {
    body=`<div class="fog cool"><div class="bg"></div><div class="pad">
      ${cardHead('plan','报告已出','采样 10/15 · 出具 10/21','紧绷','warn')}
      <div style="font-size:19px;font-weight:600;margin-top:13px">HPA 轴：紧绷</div>
      <div class="zh-loose" style="font-size:13.5px;color:var(--onD2);margin-top:7px">早上启动不了，晚上关不掉 —— 和你说的「醒来疲惫、入睡变晚」对得上。</div></div></div>
    ${cta('打开完整报告','data-act="openreport"')}
    ${S.retestScheduled?`<div class="row" style="gap:8px;padding:12px;border-radius:14px;background:rgba(220,245,90,.35)">
      <span style="width:22px;height:22px;border-radius:50%;background:var(--lime);display:flex;align-items:center;justify-content:center;flex:none">${ic('check',13,2.4,'var(--ink)')}</span>
      <span style="font-size:12.5px;font-weight:500;color:var(--ink2)">已安排复测 · 10/24 + 10/25，相同时间点</span></div>`
    :`<button data-act="retest" style="width:100%;padding:13px;border-radius:99px;background:#fff;border:1.2px solid rgba(16,16,17,.75);
      font-size:13px;font-weight:600">再采 2 天 —— 确认这个状态</button>`}`;
  }
  return sheetHead('唾液采集')+`
    <div class="row" style="gap:7px;padding:6px 20px 0">
      <span style="width:6px;height:6px;border-radius:50%;background:${S.saliva===0?'var(--ink3)':'var(--lime)'}"></span>
      <span style="font-size:12.5px;font-weight:500;color:var(--ink2)">${status}</span></div>
    <div class="scroll" style="padding:16px 20px 40px;display:flex;flex-direction:column;gap:16px">${body}</div>`;
}

/* -- Guidance (collection steps) -- */
const GSTEPS=[['清水漱口','漱 10 秒后吐掉。不要刷牙、不要用漱口水 —— 两者都会让结果失真。'],
  ['等待 10 分钟','让口腔回到基线。等待期间不吃不喝。'],
  ['含住采样棉 2 分钟','放在舌下，不要咀嚼。浸透即可 —— 不用使劲。'],
  ['放回管中，封好','不碰棉头，直接放入，按下管盖直到咔哒一声。'],
  ['标注时间点','写上时间点和实际时刻 —— 标错会让这管结果作废。']];
function shGuidance(){
  const i=S.stepIndex, pt=S.activePoint!=null?S.points[S.activePoint]:null;
  return `<div style="position:relative;height:100%;display:flex;flex-direction:column;background:var(--page)">
    <div style="position:absolute;top:0;left:0;right:0;height:56%;overflow:hidden">
      <img src="Assets/guide${i+1}.png" style="width:100%;height:100%;object-fit:cover;object-position:top">
      <div style="position:absolute;inset:0;background:linear-gradient(180deg,transparent 45%,rgba(237,237,236,.65) 80%,var(--page) 100%)"></div></div>
    <div class="row" style="position:relative;padding:18px 22px 0">
      <span class="row" style="gap:7px;padding:7px 11px;border-radius:99px;background:rgba(255,255,255,.85)">
        <span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
        <span style="font-size:12px;font-weight:600;color:var(--ink2)">${pt?pt.name:'采集'}</span></span>
      <button data-act="closeguidance" style="margin-left:auto;width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.9);
        display:flex;align-items:center;justify-content:center">${ic('close',13,2.3,'var(--ink2)')}</button></div>
    <div style="flex:1"></div>
    <div style="position:relative;padding:0 22px max(20px, env(safe-area-inset-bottom))">
      <div class="kicker">第 ${i+1} 步 · 共 5 步</div>
      <div class="serif" style="font-size:27px;font-weight:600;line-height:1.35;margin-top:8px">${GSTEPS[i][0]}</div>
      <div class="zh-loose" style="font-size:13.5px;color:var(--ink2);margin-top:10px">${GSTEPS[i][1]}</div>
      ${i===1?`<div class="row" style="gap:8px;margin-top:14px;padding:9px 12px;border-radius:99px;background:rgba(220,245,90,.45);width:fit-content">
        ${ic('bell',12,2,'var(--ink)')}<span style="font-size:12px;font-weight:500;color:var(--ink2)">Aira 会在 10 分钟后提醒你</span></div>`:''}
      <div class="row" style="gap:5px;margin-top:20px">
        ${[0,1,2,3,4].map(k=>`<span style="flex:1;height:3px;border-radius:99px;background:${k<=i?'var(--ink)':'rgba(16,16,17,.12)'}"></span>`).join('')}</div>
      <div class="row" style="gap:10px;margin-top:16px">
        ${i>0?`<button data-act="gback" style="width:52px;height:52px;border-radius:50%;background:#fff;border:1px solid var(--hair);
          display:flex;align-items:center;justify-content:center;flex:none">${ic('chevron',14,2.2,'var(--ink)','transform:rotate(180deg)')}</button>`:''}
        ${cta(i===4?'这管完成':'下一步','data-act="gnext"')}</div></div></div>`;
}

/* -- Report：唾液检测后的 T0 报告（report.html 原型，iframe 承载） -- */
function shReport(){
  return `<div class="grab"></div>
    <button data-act="closesheet" style="position:absolute;top:16px;right:16px;z-index:5;width:32px;height:32px;
      border-radius:50%;background:rgba(255,255,255,.92);box-shadow:0 2px 8px rgba(0,0,0,.12);
      display:flex;align-items:center;justify-content:center">${ic('close',12,2.3,'var(--ink2)')}</button>
    <iframe id="reportframe" src="report.html" title="唾液报告" style="flex:1;width:100%;border:0"></iframe>`;
}
function shReportLegacy(){
  const ch=S.reportChapter;
  let body='';
  if(ch===0){
    body=`<div class="litecard">${sectionLabel('事实')}
      <div style="font-size:14px;line-height:1.6;margin-top:8px">10/15 共五次采样：4.20 / 5.53 / 2.33 / 1.69 / 1.29 ng/mL。</div>
      <div class="row" style="gap:6px;margin-top:10px">${['唾液 · Eurofins','原始单位：ng/mL'].map(s=>
        `<span style="font-size:10.5px;color:var(--ink2);padding:4px 9px;border-radius:99px;background:#fff">${s}</span>`).join('')}</div></div>
    <div class="fog cool"><div class="bg"></div><div class="pad">
      <div class="cardhead"><div class="ibadge">${ic('breath',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">HPA 轴</div><div class="b">唾液 · 10/15 · 5 个点</div></div>
        ${chipEl('调节变慢','warn')}</div>
      <div class="row" style="gap:7px;align-items:baseline;margin-top:12px">
        <span style="font-size:26px;font-weight:600;color:var(--amber)">紧绷</span>
        <span style="font-size:12.5px;color:var(--onD2)">透支</span></div>
      <div style="font-size:12.5px;color:var(--onD2);margin-top:5px">早上启动不了，晚上关不掉</div>
      <div style="margin-top:10px">${hpaDeviation()}</div>
      <div style="font-size:10px;color:var(--onD3);margin-top:4px">— — 虚线 = 「平衡」的参考形状</div>
      <div style="display:flex;flex-direction:column;gap:12px;margin-top:12px">
        ${[['var(--sky)','早上启动不了','醒后该有的上升没有出现 —— 身体没进入就绪状态，所以头一两个小时发闷。','CAR 32%','预期 >50%','var(--sky)'],
           ['var(--coral)','全天关不掉','该下降的时段始终没降 —— 身体持续警觉，放松和入睡都变得更难。','AUCg 33.3','平衡值 22.0','var(--amber)']]
          .map(r=>`<div class="row" style="gap:10px;align-items:flex-start">
          <span style="width:12px;height:12px;border-radius:4px;background:${r[0]};opacity:.8;flex:none;margin-top:4px"></span>
          <div style="flex:1"><div style="font-size:13.5px;font-weight:600">${r[1]}</div>
            <div class="zh-loose" style="font-size:11.5px;color:var(--onD2);margin-top:3px">${r[2]}</div></div>
          <div style="text-align:right;flex:none"><div class="num" style="font-size:13px;color:${r[5]}">${r[3]}</div>
            <div style="font-size:9.5px;color:var(--onD3);margin-top:1px">${r[4]}</div></div></div>`).join('')}</div>
      <div class="hair-d" style="margin:13px 0"></div>
      ${stateStrip(3)}
      <div style="font-size:12.5px;font-weight:600;line-height:1.6;margin-top:13px">透支 = 该启动时启动不了，该停下时停不下来。</div>
      <div style="font-size:12px;color:var(--onD2);margin-top:2px">和你说的「醒来疲惫、入睡变晚」对得上。</div>
      <div class="row" style="gap:7px;margin-top:12px">${chipEl('DHEA 2.1 偏低','warn')}${chipEl('睾酮/皮质醇 0.38','off')}</div>
      ${qualifier('只有一天','只采了一天。补采「醒后 +30 分钟」与「睡前」两个点，确认这是稳定状态，而不是单日波动。','安排复测','data-act="retest"')}
      <div style="display:flex;gap:7px;flex-wrap:wrap;margin-top:14px">
        ${[['「透支」是什么意思？','该启动时启动不了，该停下时停不下来。晨间上升没有出现（CAR 32%，预期 >50%），下午和晚上也始终没降（AUCg 33.3，平衡值 22.0）。'],
           ['和我的睡眠有关系吗？','方向上有关：晚上关不掉会让入睡更难，你的入睡点比平时晚了 50 分钟。但只采了一天，我分不清是因果还是巧合。'],
           ['怎么才能弄清楚？','在相同时间点再采 2 天，并记录当天是否有夜间照护。形状在两天里重复出现，才算稳定状态。']]
          .map((q,i)=>`<button class="evchip" data-qa="${i}" style="font-size:11px">${ic('ask',11,2,'var(--lime)')} ${q[0]}</button>
            <div id="qa-${i}" class="zh-loose" style="display:none;width:100%;font-size:12px;color:var(--onD2);
              padding:10px 12px;border-radius:11px;background:rgba(255,255,255,.06)">${q[1]}</div>`).join('')}</div>
    </div></div>`;
  } else if(ch===1){
    body=`<div class="litecard">${sectionLabel('事实')}
      <div style="font-size:14px;line-height:1.7;margin-top:8px">设备：皮质醇在 14:00–16:00 最低。<br>自评：5 天里有 4 天，14:00 打了 1–2 分。</div></div>
    <div class="fog cool"><div class="bg"></div><div class="pad">
      <div class="cardhead"><div class="ibadge">${ic('pulse',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">感受 vs 测量</div><div class="b">设备 × 自评</div></div>
        ${chipEl('5 天中 4 天吻合','sky')}</div>
      <div style="margin-top:12px">${dualTrack()}</div>
      <div class="zh-loose" style="font-size:13.5px;margin-top:8px">你在下午和傍晚持续走低 —— 正是你说「感觉垮掉」的那段时间。</div>
      ${qualifier('第 5 天不吻合','那天 14:00 自评 3 分。单日唾液仍无法确认因果。')}</div></div>
    <div class="fog flat"><div class="bg"></div><div class="pad">
      <div class="cardhead"><div class="ibadge" style="background:rgba(220,245,90,.2)"><span style="color:var(--lime);font-weight:700;font-size:13px">?</span></div>
        <div class="tt"><div class="a">Aira 的一个假设</div></div>${chipEl('未证实','off')}</div>
      <div style="font-size:17px;font-weight:600;line-height:1.5;margin-top:12px">睡眠变短，和皮质醇有关吗？</div>
      ${evid('支持','var(--lime)',['近 7 天每晚少睡 64 分钟','16:00 皮质醇 1.69 —— 低于常见区间','5 天里 4 天自评午后垮掉'])}
      ${evid('反对 / 未知','var(--coral)',['唾液只采了 1 天','夜间照护与工作冲刺重叠 —— 分不开','采样前是否停用生物素未核实'])}
      ${qualifier('如何验证','在相同时间点再采 2 天，并记录是否有夜间照护。只有重复出现的形状才算稳定。')}</div></div>`;
  } else {
    body=`<div class="litecard">${sectionLabel('这一章为什么存在')}
      <div style="font-size:17px;font-weight:600;line-height:1.5;margin-top:8px">因为「尚不可知」和结论同样重要。</div>
      <div class="zh-loose" style="font-size:13px;color:var(--ink2);margin-top:6px">如果 Aira 把注意事项藏进灰色小字，你会跳过 —— 而我们就是在假装全知。</div></div>
    <div class="fog alert"><div class="bg"></div><div class="pad">
      ${cardHead('info','时间点与样本量','影响状态判定','1 天','warn')}
      <div class="row" style="gap:5px;margin-top:14px">${['C1','C2','C3','C4','C5'].map(s=>`<div style="flex:1;text-align:center">
        <div style="height:22px;border-radius:6px;background:var(--lime)"></div>
        <div style="font-size:8.5px;color:var(--onD3);margin-top:5px">${s}</div></div>`).join('')}</div>
      <div class="zh-loose" style="font-size:12.5px;color:var(--onD2);margin-top:12px">五个点都采齐了，可以计算状态。但只有一天 —— 单日数据上「平衡」与「透支」会重叠。</div></div></div>
    <div class="fog flat"><div class="bg"></div><div class="pad">
      <div style="font-size:10.5px;font-weight:600;letter-spacing:2px;color:var(--onD3)">三件我们不下结论的事</div>
      <div style="display:flex;flex-direction:column;gap:0;margin-top:13px">
      ${[['夜间照护 vs 工作压力 —— 哪个是主因','两者重叠；分开它们需要一个只有其中之一的窗口'],
         ['生物素是否影响了这次检测','采样前未核实。免疫检测法对生物素敏感'],
         ['DHEA 偏低是长期还是近期','只有一次测量，没有基线可比']].map((p,i)=>`
        ${i?'<div class="hair-d" style="margin:11px 0 9px"></div>':''}
        <div><div style="font-size:13.5px;font-weight:600;line-height:1.5">${p[0]}</div>
          <div class="zh-loose" style="font-size:12px;color:var(--onD2);margin-top:3px">${p[1]}</div></div>`).join('')}</div></div></div>
    <div class="row" style="gap:8px;align-items:flex-start;padding:9px 12px;border-radius:11px;background:rgba(16,16,17,.04);
         border:1px dashed rgba(255,184,92,.9)">
      <span style="color:var(--amber);font-weight:700;font-size:12px">!</span>
      <div><div style="font-size:11.5px;font-weight:500">Apple Health · 模拟数据</div>
        <div style="font-size:10px;color:var(--ink3);margin-top:1px">本演示使用模拟数据，并非真实检测结果</div></div></div>`;
  }
  return `<div class="grab"></div>
    <div class="row" style="padding:16px 20px 0">
      <div style="flex:1">${sectionLabel('唾液报告 · 采样 10/15')}
        <div style="font-size:20px;font-weight:600;margin-top:2px">你的状态：透支</div></div>
      <button data-act="closesheet" style="width:32px;height:32px;border-radius:50%;background:var(--hair2);
        display:flex;align-items:center;justify-content:center">${ic('close',12,2.3,'var(--ink2)')}</button></div>
    <div class="chtabs">${['01 HPA 轴','02 对照你的感受','03 仍不确定'].map((c,i)=>
      `<button class="${ch===i?'on':''}" data-act="chapter" data-v="${i}">${c}</button>`).join('')}</div>
    <div class="scroll" style="padding:16px 20px 40px;display:flex;flex-direction:column;gap:16px">
      ${body}
      ${cta('生成计划','data-act="buildplan"')}
    </div>`;
}
function evid(title,c,items){
  return `<div style="margin-top:13px"><div style="font-size:9.5px;font-weight:700;letter-spacing:2px;color:${c}">${title}</div>
    <div style="display:flex;flex-direction:column;gap:5px;margin-top:6px">${items.map(s=>
      `<div class="row" style="gap:7px;align-items:flex-start"><span style="color:var(--onD3)">·</span>
       <span class="zh-loose" style="font-size:12px;color:var(--onD2)">${s}</span></div>`).join('')}</div></div>`;
}
function dualTrack(w=312,h=110){
  const cort=[[7,.55],[9,.75],[11,.45],[13,.3],[15,.2],[17,.22],[19,.2],[21,.17]];
  const felt=[[8,.65],[10,.55],[12,.5],[14,.15],[16,.18],[18,.32],[20,.3]];
  const pl=8,pr=8,pt=12,pb=26;
  const X=hr=>pl+(w-pl-pr)*(hr-7)/14, Y=v=>pt+(h-pt-pb)*(1-v);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=`<rect x="${X(14)}" y="${pt}" width="${X(16)-X(14)}" height="${h-pt-pb}" rx="6" fill="rgba(255,138,91,.12)"/>`;
  s+=`<path d="${smoothPath(cort.map(([hr,v])=>[X(hr),Y(v)]))}" stroke="var(--lime)" stroke-width="2" fill="none"/>`;
  s+=`<path d="${smoothPath(felt.map(([hr,v])=>[X(hr),Y(v)]))}" stroke="rgba(255,255,255,.75)" stroke-width="1.6" stroke-dasharray="4 3" fill="none"/>`;
  s+=`<text x="${X(15)}" y="${h-12}" fill="var(--coral)" font-size="9" text-anchor="middle">低谷</text>`;
  [8,12,16,20].forEach(hr=>s+=`<text x="${X(hr)}" y="${h-2}" fill="rgba(255,255,255,.35)" font-size="8.6" text-anchor="middle">${hr}:00</text>`);
  s+=`<text x="${pl}" y="10" fill="var(--lime)" font-size="8.6">— 皮质醇</text>
      <text x="${pl+58}" y="10" fill="rgba(255,255,255,.6)" font-size="8.6">- - 你的感受</text>`;
  return s+'</svg>';
}

/* -- Check-in -- */
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

/* -- Ask about plan -- */
function shAsk(){
  const qa=[['为什么起床时间排第一？','权重最高（9.1），而且是唯一同时作用于两端的干预 —— 定住起床时间，入睡点会自己前移。'],
    ['我需要补剂吗？','不需要。这一轮不给补剂建议 —— 你的数据还撑不起那个判断，而且行为干预的证据更强。'],
    ['做不到每天执行怎么办？','只在工作日做也可以。只要别连续中断 3 天 —— 那会把刚稳住的节律重新带偏。']];
  return sheetHead('问问这份计划')+`
    <div class="scroll" style="padding:10px 20px 40px;display:flex;flex-direction:column;gap:10px">
      ${qa.map((q,i)=>`<button data-qa="${i}" class="wcard" style="padding:15px 16px;text-align:left;width:100%">
        <span class="row" style="gap:9px">${ic('ask',15,2,'var(--ink)')}<span style="flex:1;font-size:14px;font-weight:500">${q[0]}</span>
          ${ic('chevron',11,2.2,'var(--ink3)','transform:rotate(90deg)')}</span></button>
        <div id="qa-${i}" class="zh-loose" style="display:none;font-size:13px;color:var(--ink2);padding:2px 16px 8px">${q[1]}</div>`).join('')}</div>`;
}

/* -- Arrange -- */
function shArrange(){
  const a=S.sheetArg;
  const slots=['早晨 · 07:00','下午 · 13:30','傍晚 · 18:00','睡前 · 22:00'];
  const rec=(a.icon==='meditate'||a.icon==='read')?3:(a.icon==='coffee'?1:2);
  if(S._arrMin==null){ S._arrMin=a.defaultMin||20; S._arrSlot=rec; }
  const reason=[,'下午 —— 你 13:10–15:50 的久坐时段，正好压在精力低谷上。',
    '傍晚 —— 距睡前至少 3 小时，入睡点才不会被推后。',
    '睡前 —— 你的问题是晚上关不掉，这个时段收益最大。'][S._arrSlot]||'傍晚 —— 距睡前至少 3 小时。';
  return sheetHead('安排')+`
    <div class="scroll" style="padding:10px 20px 40px">
      <div class="row" style="gap:14px;margin-top:8px">
        <span style="width:92px;height:92px;border-radius:20px;background:${a.tint};display:flex;align-items:center;justify-content:center;flex:none">${ic(a.icon,40,1.6,'rgba(16,16,17,.8)')}</span>
        <div><div style="font-size:22px;font-weight:600">${a.name}</div>
          <div style="font-size:12.5px;color:var(--ink3);margin-top:4px">${a.sub}</div></div></div>
      <div style="margin-top:24px">${sectionLabel('时长（分钟）')}</div>
      <div class="row" style="gap:8px;margin-top:10px">${[10,15,20,30,45].map(m=>`<button data-act="arrmin" data-v="${m}"
        style="flex:1;padding:13px 2px;border-radius:14px;font-size:14px;${S._arrMin===m?'background:var(--ink);color:#fff;font-weight:600':'background:#fff;border:1px solid var(--hair);color:var(--ink2)'}">${m}</button>`).join('')}</div>
      <div style="margin-top:20px">${sectionLabel('时间段')}</div>
      <div style="display:flex;flex-direction:column;gap:8px;margin-top:10px">
        ${slots.map((s,i)=>`<button data-act="arrslot" data-v="${i}" class="row" style="gap:8px;padding:14px 16px;border-radius:15px;text-align:left;
          background:${S._arrSlot===i?'rgba(220,245,90,.4)':'#fff'};border:1px solid ${S._arrSlot===i?'rgba(16,16,17,.85)':'var(--hair)'}">
          <span style="font-size:14.5px;${S._arrSlot===i?'font-weight:600':''}">${s}</span>
          ${i===rec?'<span style="font-size:10px;font-weight:600;padding:3px 7px;border-radius:99px;background:var(--lime)">Aira 建议</span>':''}
          <span style="margin-left:auto">${S._arrSlot===i?ic('check',15,2.2,'var(--ink)'):''}</span></button>`).join('')}</div>
      <div class="row" style="gap:9px;align-items:flex-start;margin-top:16px;padding:13px;border-radius:15px;background:rgba(220,245,90,.4)">
        ${ic('spark',13,2,'var(--ink)','margin-top:2px')}<span class="zh-loose" style="font-size:12.5px;color:var(--ink2)">${reason}</span></div>
      <div style="margin-top:22px">${cta('加入计划','data-act="arradd"')}</div></div>`;
}

/* ================= Analyzing overlay ================= */
const $anal=document.getElementById('analyzing');
function deliverReport(){
  S.points.forEach(p=>p.done=true);
  closeSheet();
  const lines=['读取 5 个唾液时间点','与 30 天睡眠数据对齐','对照你自己的基线','区分已知与未知'];
  $anal.className='open';
  $anal.innerHTML=`<div class="fogscreen"></div>
    <div style="position:relative;height:100%;display:flex;flex-direction:column;justify-content:center;color:#fff;text-align:center;padding:0 40px">
      ${textSphere(250,80)}
      <div style="font-size:22px;font-weight:600;margin-top:26px">联合分析</div>
      <div id="an-line" style="font-size:13.5px;color:rgba(255,255,255,.62);margin-top:10px;height:20px">${lines[0]}</div>
      <div id="an-bar" style="margin:30px 46px 0">${neonBar(0)}</div>
      <div id="an-pct" class="num" style="font-size:11px;color:rgba(255,255,255,.4);margin-top:12px">0%</div>
      <div style="position:absolute;bottom:34px;left:0;right:0;font-size:11px;color:rgba(255,255,255,.34);line-height:1.7">
        这需要一点时间 —— 它在把两侧互相对照着读，<br>而不是分别打分。</div></div>`;
  let p=0;
  const t=setInterval(()=>{
    p++;
    const b=document.getElementById('an-bar'); if(!b){clearInterval(t);return;}
    b.innerHTML=neonBar(p);
    document.getElementById('an-pct').textContent=p+'%';
    if(p%25===0&&p<100) document.getElementById('an-line').textContent=lines[Math.min(3,p/25)];
    if(p>=100){ clearInterval(t);
      setTimeout(()=>{ $anal.className=''; $anal.innerHTML='';
        S.saliva=4; S.tab=1; S.unread=1; render(); },480); }
  },52);
}

/* ================= Demo autoplay ================= */
const DEMO_STEPS=[
  ['欢迎页',3.0,()=>{reset();}],
  ['连接数据',2.4,()=>{S.phase='connect';S.healthGranted=true;}],
  ['导入 30 天',4.0,()=>{beginSync();}],
  ['第一份解读',4.2,()=>{S.phase='recap';}],
  ['关于你',2.6,()=>{S.phase='profile';S.profStep=0;S.nickname='Chloe';}],
  ['训练习惯',2.4,()=>{S.phase='profile';S.profStep=1;}],
  ['健康背景',2.6,()=>{S.phase='medical';S.meds.add(BIOTIN);}],
  ['首页 · 每日循环',3.6,()=>{S.phase='main';S.tab=0;closeSheetNow();}],
  ['Aira 发起对话',3.6,()=>{S.phase='main';S.tab=1;}],
  ['为什么是唾液',3.2,()=>{S.phase='main';S.tab=1;if(!S.sent.includes('为什么是唾液？'))S.sent.push('为什么是唾液？');}],
  ['安排采集',2.6,()=>{S.phase='main';S.tab=1;if(!S.sent.includes('安排在明天'))S.sent.push('安排在明天');if(S.saliva<1)S.saliva=1;}],
  ['采集步骤',3.4,()=>{S.phase='main';S.tab=0;S.activePoint=0;S.stepIndex=1;render();openSheet('guidance');}],
  ['样本完成',2.2,()=>{closeSheetNow();S.points.forEach(p=>p.done=true);S.saliva=3;}],
  ['联合分析',6.4,()=>{deliverReport();}],
  ['报告',4.4,()=>{S.saliva=4;S.tab=1;render();openSheet('report');}],
  ['计划',4.0,()=>{closeSheetNow();S.tab=2;}],
  ['浏览计划',3.4,()=>{S.tab=2;render();
    const f=document.getElementById('planframe');
    try{ f.contentWindow.scrollTo({top:720,behavior:'smooth'}); }catch(e){} }],
];
/* 桌面端控制台在手机壳外，默认展开；手机端保持收起的右缘把手 */
const Demo={playing:false,index:0,
  expanded:window.matchMedia('(min-width:768px) and (min-height:640px)').matches,timer:null};
function closeSheetNow(){ S.sheet=null; $sheet.classList.remove('open'); $veil.classList.remove('open'); $sheet.innerHTML=''; }
function demoRun(i){
  Demo.index=i;
  const [,,fn]=DEMO_STEPS[i];
  fn();
  if(S.phase!=='syncing'&&!['guidance','report'].includes(S.sheet||'')&&i!==13) render();
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
function demoStop(){ Demo.playing=false; clearTimeout(Demo.timer); renderDemo(); }
function renderDemo(){
  const el=document.getElementById('demo');
  el.className=Demo.expanded?'expanded':'';
  el.innerHTML=`${Demo.expanded?`<div class="panel">
      <div class="head"><button class="pp" data-demo="toggle">${Demo.playing?pauseGlyph():playGlyph('var(--ink)')}</button>
        <span>${Demo.playing?DEMO_STEPS[Math.min(Demo.index,16)][0]:'播放完整流程'}</span></div>
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
    case 'getstarted': S.phase='connect'; render(); break;
    case 'phase': S.phase=v; if(v==='profile')S.profStep=S.profStep||0; render(); break;
    case 'grant': S.healthGranted=true; render(); break;
    case 'device': S.devices.has(v)?S.devices.delete(v):S.devices.add(v); render(); break;
    case 'connectnext': if(S.healthGranted) beginSync(); else {S.healthGranted=true; render();} break;
    case 'skiphome': S.phase='main'; S.tab=0; render(); break;
    case 'profstep': S.profStep=+v; render(); break;
    case 'sex': S.sex=+v; render(); break;
    case 'band': S.sessionBand=+v; render(); break;
    case 'finishonb': case 'noneapply':
      if(a==='noneapply'){S.injuries.clear();S.meds.clear();}
      S.phase='main'; S.tab=0; render(); break;
    case 'injury': S.injuries.has(v)?S.injuries.delete(v):S.injuries.add(v); render(); break;
    case 'med': S.meds.has(v)?S.meds.delete(v):S.meds.add(v); render(); break;
    case 'tab': S.tab=+v; if(S.tab===1)S.unread=0; if(S.sheet)closeSheet(); render(); break;
    case 'range': S.range=+v; S.dayIndex=Mock.days.length-1; render(); break;
    case 'sheet': openSheet(v); break;
    case 'closesheet': closeSheet(); break;
    case 'send': send(v); break;
    case 'composer': {
      const inp=document.getElementById('composer');
      if(inp&&inp.value.trim()) send(inp.value.trim());
      break; }
    case 'schedule': S.saliva=1; refreshSheet(); render(); break;
    case 'point': S.activePoint=+v; S.stepIndex=0; $sheet.innerHTML=sheetHTML('guidance'); S.sheet='guidance'; wireSheet(); break;
    case 'gback': S.stepIndex--; refreshSheet(); break;
    case 'gnext':
      if(S.stepIndex===4){
        if(S.activePoint!=null){ S.points[S.activePoint].done=true;
          if(S.saliva<2)S.saliva=2;
          if(S.points.every(p=>p.done))S.saliva=3; }
        S.sheet='testing'; $sheet.innerHTML=sheetHTML('testing'); wireSheet(); render();
      } else { S.stepIndex++; refreshSheet(); }
      break;
    case 'closeguidance': S.sheet='testing'; $sheet.innerHTML=sheetHTML('testing'); wireSheet(); break;
    case 'fastforward': deliverReport(); break;
    case 'openreport': S.sheet='report'; $sheet.innerHTML=sheetHTML('report'); wireSheet(); break;
    case 'chapter': S.reportChapter=+v; refreshSheet(); break;
    case 'buildplan': closeSheet(()=>{ S.tab=2; render(); }); break;
    case 'retest': S.retestScheduled=true; refreshSheet(); break;
    case 'deckexpand': S.deckExpanded=!S.deckExpanded; render(); break;
    case 'restoreskipped': stage().forEach(r=>{if(r.state===2)r.state=0;}); render(); break;
    case 'planseg': S.planSeg=+v; render(); break;
    case 'arrange': S._arrMin=null; S._arrSlot=null;
      openSheet('arrange',{name:v,icon:el.dataset.icon,sub:el.dataset.sub,tint:el.dataset.tint,
        defaultMin:{'快走':20,'跑步':30,'骑行':40,'力量':45,'游泳':30,'跳绳':10,
          '呼吸练习':10,'拉伸':8,'散步':15,'咖啡':15,'跳舞':15,'阅读':20}[v]||20}); break;
    case 'arrmin': S._arrMin=+v; refreshSheet(); break;
    case 'arrslot': S._arrSlot=+v; refreshSheet(); break;
    case 'arradd': {
      const a=S.sheetArg, slots=['早晨 · 07:00','下午 · 13:30','傍晚 · 18:00','睡前 · 22:00'];
      S.arranged.push({name:a.name,icon:a.icon,tint:a.tint,time:slots[S._arrSlot],minutes:S._arrMin,done:0});
      closeSheet(()=>render()); break; }
    case 'feel': S.feel=+v; refreshSheet(); break;
    case 'logfeel': S.loggedToday=true; closeSheet(()=>render()); break;
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
  const sc=document.getElementById('scrub');
  if(sc){
    const n=+sc.dataset.n;
    const pick=x=>{
      const r=sc.getBoundingClientRect();
      const w=r.width, pl=26/352*w, pr=14/352*w;
      let i=Math.round((x-r.left-pl)/(w-pl-pr)*(n-1));
      i=Math.max(0,Math.min(n-1,i));
      const di=Mock.days.length-n+i;
      if(di!==S.dayIndex){ S.dayIndex=di; render(); }
    };
    sc.addEventListener('click',e=>pick(e.clientX));
    let dragging=false;
    sc.addEventListener('pointerdown',e=>{dragging=true;});
    sc.addEventListener('pointermove',e=>{ if(dragging&&e.buttons) pick(e.clientX); });
    sc.addEventListener('pointerup',()=>dragging=false);
  }
  document.querySelectorAll('[data-self]').forEach(b=>b.addEventListener('click',()=>{
    S.selfSelected=+b.dataset.self; render();
  }));
  const card=document.getElementById('topcard');
  if(card){
    let x0=null,dx=0,moved=false;
    const hints=()=>document.getElementById('swipehints');
    card.addEventListener('pointerdown',e=>{ x0=e.clientX; dx=0; moved=false; card.setPointerCapture(e.pointerId); });
    card.addEventListener('pointermove',e=>{
      if(x0==null)return; dx=e.clientX-x0;
      if(Math.abs(dx)>6)moved=true;
      card.style.transform=`translateX(${dx}px) rotate(${dx/24}deg)`;
      card.style.transition='none';
      const h=hints(); if(h)h.style.opacity=Math.abs(dx)>24?1:0;
    });
    card.addEventListener('pointerup',e=>{
      if(x0==null)return;
      const d=deck()[0];
      if(dx>96&&d){ flyOff(card,1,()=>{d.state=1;S.deckExpanded=false;render();}); }
      else if(dx<-96&&d){ flyOff(card,-1,()=>{d.state=2;S.deckExpanded=false;render();}); }
      else { card.style.transition='transform .3s cubic-bezier(.3,.9,.4,1.2)'; card.style.transform='none';
        const h=hints(); if(h)h.style.opacity=0; }
      x0=null;
    });
  }
}
function flyOff(card,dir,cb){
  card.style.transition='transform .26s ease-out, opacity .26s';
  card.style.transform=`translateX(${dir*480}px) rotate(${dir*18}deg)`;
  card.style.opacity='0';
  setTimeout(cb,240);
}
function wireSheet(){
  const rf=document.getElementById('reportframe');
  if(rf){ rf.addEventListener('load',()=>wireMock(rf,()=>closeSheet(()=>{S.tab=2;render();})));
          wireMock(rf,()=>closeSheet(()=>{S.tab=2;render();})); }
}

/* 原型 iframe 通用接线：铺满宽度 + 把页内 CTA 接回主流程 */
function wireMock(iframe,onCta){
  try{
    const d=iframe.contentDocument; if(!d||!d.body) return;
    if(!d.getElementById('host-patch')){
      const st=d.createElement('style'); st.id='host-patch';
      st.textContent='#phone{width:100%!important;max-width:100%!important;padding-top:max(26px,env(safe-area-inset-top))!important}';
      d.head.appendChild(st);
    }
    const btn=d.querySelector('button.cta');
    if(btn&&!btn.dataset.wired){ btn.dataset.wired='1'; btn.addEventListener('click',onCta); }
  }catch(e){}
}

/* 计划 iframe：隐藏原型自带的 tab 栏（由主壳接管），底部留出主壳 tab 栏的高度 */
(function(){
  const pf=document.getElementById('planframe');
  const patch=()=>{
    try{
      const d=pf.contentDocument; if(!d||!d.head) return;
      if(d.getElementById('host-patch')) return;
      const st=d.createElement('style'); st.id='host-patch';
      st.textContent='.tab-bar{display:none!important}.page{padding-bottom:132px!important}';
      d.head.appendChild(st);
    }catch(e){}
  };
  pf.addEventListener('load',patch); patch();
})();

/* 首读报告 iframe：CTA「继续，看看另一半」→ 进入 About you */
(function(){
  const fr=document.getElementById('frframe');
  const go=()=>{ S.phase='profile'; S.profStep=0; render(); };
  fr.addEventListener('load',()=>wireMock(fr,go));
  wireMock(fr,go);
})();

/* boot */
render();

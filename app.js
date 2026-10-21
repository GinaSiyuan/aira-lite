/* Aira Lite — web demo. Mirrors the SwiftUI prototype's Lite core loop.
   All data is mock; mirrors Model.swift so numbers stay consistent across screens. */
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
    {date:'10/01',wd:'Wed',sleep:'7:22',sd:-6, wk:1,am:7, longest:'4:40',onset:'23:35',od:-5, rec:44,rd:-3, hrv:50,rhr:57,steps:'10,210',note:'The steadiest night this week.'},
    {date:'10/02',wd:'Thu',sleep:'7:10',sd:-18,wk:1,am:10,longest:'4:05',onset:'23:45',od:5,  rec:46,rd:-1, hrv:49,rhr:57,steps:'9,640', note:'Within normal range.'},
    {date:'10/03',wd:'Fri',sleep:'6:48',sd:-40,wk:2,am:16,longest:'3:20',onset:'00:02',od:22, rec:50,rd:3,  hrv:47,rhr:58,steps:'8,980', note:'Friday starts drifting later.'},
    {date:'10/04',wd:'Sat',sleep:'7:35',sd:7,  wk:1,am:8, longest:'4:55',onset:'23:50',od:10, rec:43,rd:-4, hrv:51,rhr:56,steps:'6,320', note:'Some of it came back over the weekend.'},
    {date:'10/05',wd:'Sun',sleep:'7:04',sd:-24,wk:2,am:13,longest:'3:45',onset:'23:58',od:18, rec:47,rd:0,  hrv:48,rhr:58,steps:'7,450', note:'Still near baseline.'},
    {date:'10/06',wd:'Mon',sleep:'6:58',sd:-30,wk:2,am:15,longest:'3:30',onset:'00:00',od:20, rec:49,rd:2,  hrv:48,rhr:58,steps:'9,120', note:'A new week begins.'},
    {date:'10/07',wd:'Tue',sleep:'6:50',sd:-38,wk:2,am:17,longest:'3:10',onset:'00:05',od:25, rec:52,rd:5,  hrv:46,rhr:59,steps:'8,700', note:'The trend starts to deviate.'},
    {date:'10/08',wd:'Wed',sleep:'7:06',sd:-22,wk:1,am:9, longest:'4:10',onset:'23:50',od:10, rec:51,rd:4,  hrv:47,rhr:58,steps:'9,140', note:'A reasonably whole night.'},
    {date:'10/09',wd:'Thu',sleep:'6:54',sd:-34,wk:2,am:18,longest:'3:05',onset:'00:05',od:25, rec:55,rd:8,  hrv:45,rhr:59,steps:'7,820', note:'Sleep onset starts sliding later.'},
    {date:'10/10',wd:'Fri',sleep:'—',  sd:0,  wk:0,am:0, longest:'—',  onset:'—',  od:0,  rec:0, rd:0,  hrv:0, rhr:0, steps:'—',    note:'No record this day — excluded from the mean.'},
    {date:'10/11',wd:'Sat',sleep:'6:12',sd:-76,wk:4,am:51,longest:'1:40',onset:'00:40',od:60, rec:68,rd:21, hrv:38,rhr:63,steps:'5,410', note:'The most fragmented night.'},
    {date:'10/12',wd:'Sun',sleep:'6:36',sd:-52,wk:3,am:35,longest:'2:20',onset:'00:20',od:40, rec:61,rd:14, hrv:41,rhr:61,steps:'8,900', note:'A slight rebound.'},
    {date:'10/13',wd:'Mon',sleep:'6:24',sd:-64,wk:3,am:42,longest:'2:00',onset:'00:30',od:50, rec:64,rd:17, hrv:40,rhr:62,steps:'8,260', note:'Matches what you said about waking up tired.'},
    {date:'10/14',wd:'Tue',sleep:'6:31',sd:-57,wk:2,am:26,longest:'2:45',onset:'00:15',od:35, rec:60,rd:13, hrv:42,rhr:61,steps:'6,180', note:"Today isn't over yet."},
  ],
  hm(s){ const p=s.split(':').map(Number); return p.length===2 ? p[0]+p[1]/60 : 0; },
  recent(n){ return this.days.slice(-n); },
  avg(n,f){ const v=this.recent(n).filter(d=>d.sleep!=='—').map(f); return v.reduce((a,b)=>a+b,0)/v.length; },
  avgSleepText(n){ const h=this.avg(n,d=>this.hm(d.sleep)); const m=Math.round(h*60);
    return `${Math.floor(m/60)}:${String(m%60).padStart(2,'0')}`; },
};
const RANGES = [ {t:'7d',days:7,base:'prev 28-day baseline',grain:'Daily'},
                 {t:'14d',days:14,base:'prev 14 days',grain:'Daily'},
                 {t:'30d',days:14,base:'prev 90-day baseline',grain:'Daily'} ]; // 30d window capped by mock span

/* ================= State (App in Model.swift) ================= */
const S = {
  phase:'welcome', tab:0, profStep:0,
  nickname:'', age:32, sex:0, sessionBand:1, years:2,
  injuries:new Set(), meds:new Set(),
  healthGranted:false, devices:new Set(), syncedItems:0,
  saliva:0, // 0 notScheduled 1 scheduled 2 collecting 3 shipped 4 reportReady
  points:[
    {name:'C1 · 30 min after waking', when:'06:45', hint:'Stay in bed; take the first tube before moving', done:false},
    {name:'C2 · 45 min after waking', when:'07:15', hint:'30 min after C1 — this pair defines CAR', done:false},
    {name:'C3 · Before lunch',        when:'11:30', hint:'Before eating, to avoid food interference', done:false},
    {name:'C4 · 16–17h',              when:'16:30', hint:'The afternoon trough', done:false},
    {name:'C5 · Before bed',          when:'22:30', hint:'The decisive tube — it sets the state group', done:false},
  ],
  activePoint:null, stepIndex:0, retestScheduled:false,
  sent:[], unread:2,
  dayIndex:Mock.days.length-1, range:0,
  selfSelected:13, loggedToday:false, feel:2,
  sheet:null, sheetArg:null,
  deckExpanded:false, reportChapter:0,
  arranged:[], planSeg:0,
  deviceRecs:[
    {tag:'Movement',col:'var(--sky)',title:'Stand 2 min every hour',
     because:'You sat 2 h 40 m straight from 13:10–15:50 — right on the energy trough.',
     evidence:['Activity · 7d','Self-report 14:00'],constraint:'Weekdays · start this afternoon',
     timeline:'Felt within days',impact:null,saliva:false,state:0,done:0},
    {tag:'Sleep',col:'var(--violet)',title:'Phone down at 22:30',
     because:'Median sleep onset over 5 days is 00:30 — 50 min later than your baseline.',
     evidence:['Sleep onset · 5d','Baseline 28d'],constraint:'Daily · try one week',
     timeline:'Onset usually moves in 1–2 weeks',impact:null,saliva:false,state:0,done:0},
    {tag:'Movement',col:'var(--sky)',title:'20-min brisk walk in the afternoon',
     because:'Only 2 workouts this week, and Saturday was your most fragmented night.',
     evidence:['Workouts · 7d','Sleep 10/12'],constraint:'3×/week · no added intensity',
     timeline:'Felt within a week',impact:null,saliva:false,state:0,done:0},
  ],
  reportRecs:[
    {tag:'Lifestyle',col:'var(--sky)',title:'Fixed wake time (±30 min)',
     because:'The only lever acting on both ends — morning rise and evening shut-off. Set the wake time and onset drifts earlier on its own.',
     evidence:['CAR 32%','Sleep onset · 5d','AUCg 33.3'],constraint:'Daily · ranks above supplements and exercise',
     timeline:'~2 weeks to feel it · 6 weeks full effect',impact:9.1,saliva:true,state:0,done:0},
    {tag:'Breathwork',col:'var(--lime)',title:'10 min slow breathing before bed',
     because:'Your evening cortisol never comes down (1.29 before bed vs 0.4 balanced) — this targets exactly that point.',
     evidence:['Bedtime cortisol 1.29','HRV · 14d'],constraint:'5×/week · no other evening tasks',
     timeline:'~2 weeks to feel it',impact:8.4,saliva:true,state:0,done:0},
    {tag:'Nutrition',col:'var(--amber)',title:'Lunch carbs under 40 g',
     because:'Your 14:00–16:00 trough is your lowest cortisol window — heavy lunch carbs deepen it.',
     evidence:['Cortisol 16:30 · 1.69','Self-report 14:00'],constraint:'Weekdays · targets the afternoon dip',
     timeline:'~1 week to notice',impact:7.2,saliva:true,state:0,done:0},
  ],
};
const stage = () => S.saliva===4 ? S.reportRecs : S.deviceRecs;
const deck  = () => stage().filter(r=>r.state===0);
const accepted = () => [...S.deviceRecs,...S.reportRecs].filter(r=>r.state===1);
const nick = () => S.nickname.trim() || 'Chloe';
const donePts = () => S.points.filter(p=>p.done).length;

function reset(){
  Object.assign(S,{phase:'welcome',tab:0,profStep:0,nickname:'',healthGranted:false,syncedItems:0,
    saliva:0,activePoint:null,stepIndex:0,retestScheduled:false,sent:[],unread:2,
    dayIndex:Mock.days.length-1,range:0,loggedToday:false,sheet:null,reportChapter:0,arranged:[],planSeg:0});
  S.injuries.clear(); S.meds.clear(); S.devices.clear();
  S.points.forEach(p=>p.done=false);
  [...S.deviceRecs,...S.reportRecs].forEach(r=>{r.state=0;r.done=0;});
}

/* ================= Tiny chart builders (SVG) ================= */
function smoothPath(pts){ // cubic through points, horizontal controls
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
  const names=['Depleted','Balanced','Activated','Tense','Over'];
  return `<div class="statestrip">`+names.map((n,i)=>
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
function neonBar(pct){ // progress reveal
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
function face(level, size=24, color='#6B6B6E', lw=1.7){ // 0 calm … 4 very tense
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
const faceNames=['Calm','Fine','A bit tense','Tense','Very tense'];

function hpaDeviation(w=312,h=150){ // user vs balanced reference
  const u=Mock.hpaUser,b=Mock.hpaBalanced,max=6.6;
  const pl=8,pr=30,pt=10,pb=28;
  const X=i=>pl+(w-pl-pr)*i/4, Y=v=>pt+(h-pt-pb)*(1-v/max);
  const up=u.map((v,i)=>[X(i),Y(v)]), bp=b.map((v,i)=>[X(i),Y(v)]);
  const pu=smoothPath(up), pb2=smoothPath(bp);
  // area between curves: morning (sky, user below ref) + day (coral, user above ref)
  const area=(i0,i1,col)=>{
    let d=smoothPath(up.slice(i0,i1+1));
    const rev=bp.slice(i0,i1+1).reverse();
    d+=` L${rev[0][0]} ${rev[0][1]}`+smoothPath(rev).slice(1).replace(/^M[^C]*/,'')||'';
    let d2=smoothPath(up.slice(i0,i1+1));
    const revd=smoothPath(rev);
    return `<path d="${d2} L${rev[0][0].toFixed(1)} ${rev[0][1].toFixed(1)} ${revd.slice(revd.indexOf('C')>0?revd.indexOf('C'):1)} Z" fill="${col}" opacity=".32"/>`;
  };
  const labels=['Wake','+30m','Pre-lunch','16–17','Bed'];
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=area(0,1,'var(--sky)')+area(1,4,'var(--coral)');
  s+=`<path d="${pb2}" stroke="rgba(255,255,255,.45)" stroke-width="1.3" stroke-dasharray="3 3" fill="none"/>`;
  s+=`<path d="${pu}" stroke="var(--amber)" stroke-width="2.2" fill="none" stroke-linecap="round"/>`;
  u.forEach((v,i)=>{ s+=`<circle cx="${X(i)}" cy="${Y(v)}" r="3.4" fill="var(--amber)"/>`; });
  s+=`<circle cx="${X(4)}" cy="${Y(u[4])}" r="5.4" fill="#fff"/>`;
  s+=`<text x="${X(4)-2}" y="${Y(u[4])-11}" fill="#fff" font-size="11" font-weight="600" text-anchor="end">1.29</text>`;
  labels.forEach((l,i)=>{ s+=`<text x="${X(i)}" y="${h-12}" fill="rgba(255,255,255,.4)" font-size="9"
      text-anchor="${i===0?'start':i===4?'end':'middle'}" ${i===4?'font-weight="700" fill="#fff"':''}>${l}</text>`; });
  s+=`<text x="${X(4)}" y="${h-1}" fill="rgba(255,255,255,.35)" font-size="8" text-anchor="end">Decisive</text>`;
  return s+'</svg>';
}
function fiveTubesCurve(w=300,h=96){
  const v=[0.52,0.92,0.42,0.22,0.12], labels=['Wake','+30m','Pre-lunch','16–17h','Bed'];
  const pl=10,pr=10,pt=12,pb=24;
  const X=i=>pl+(w-pl-pr)*i/4, Y=x=>pt+(h-pt-pb)*(1-x);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">
    <path d="${smoothPath(v.map((x,i)=>[X(i),Y(x)]))}" stroke="var(--lime)" stroke-width="2" fill="none" stroke-linecap="round"/>`;
  v.forEach((x,i)=>{ s+=`<circle cx="${X(i)}" cy="${Y(x)}" r="4" fill="#151514" stroke="var(--lime)" stroke-width="2"/>
    <text x="${X(i)}" y="${h-8}" fill="rgba(255,255,255,.45)" font-size="8.6" text-anchor="${i===0?'start':i===4?'end':'middle'}">${labels[i]}</text>`;});
  return s+'</svg>';
}
function sleepAxis(day,w=312,h=92){ // night timeline with blocks and wake gaps
  const total=Mock.hm(day.sleep), longest=Mock.hm(day.longest), n=Math.max(1,day.wk);
  const segs=[]; segs.push({len:longest,sleep:true,main:true});
  const rest=Math.max(0.2,total-longest), per=rest/n, gap=(day.am/n)/60;
  for(let i=0;i<n;i++){ segs.push({len:gap,sleep:false}); segs.push({len:per,sleep:true}); }
  const span=segs.reduce((a,s)=>a+s.len,0);
  const pl=2,pr=2,bt=24,bh=34;
  let x=pl, s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=`<text x="${pl}" y="12" fill="rgba(255,255,255,.35)" font-size="9">22:30</text>
      <text x="${w-pr}" y="12" fill="rgba(255,255,255,.35)" font-size="9" text-anchor="end">07:59</text>
      <text x="${w/2}" y="12" fill="rgba(255,255,255,.75)" font-size="9.5" font-weight="600" text-anchor="middle">Longest block ${day.longest}</text>`;
  let mainX=0,mainW=0;
  segs.forEach(seg=>{
    const sw=(w-pl-pr)*seg.len/span;
    if(seg.sleep){
      // sub-stripes to fake stages
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
      <text x="${pl+14}" y="${h-4}" fill="var(--coral)" font-size="9.4">Asleep ${day.onset} · ${day.od} min later than usual</text>`;
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
      <div style="font-size:14px;font-weight:600;color:var(--ink)">${d.sleep==='—'?'No data this day':'Sleep '+d.sleep}</div>
      <div style="font-size:10.5px;color:var(--ink3);margin-top:1px">${d.sleep==='—'?`${d.wd} ${d.date}`:`${d.wd} ${d.date} · Asleep ${d.onset} · Woke ${d.wk} ×`}</div>
    </div>${s}</div>`;
}
function selfTrend(){
  const vals=Mock.selfCheck, n=vals.length;
  const w=352,hh=120,pl=14,pr=14,top=18,bot=24;
  const X=i=>pl+(w-pl-pr)*i/(n-1), Y=v=>top+(hh-top-bot)*(1-(v-1)/3.4);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${hh}" style="display:block">`;
  s+=`<text x="${pl}" y="12" fill="var(--ink3)" font-size="9">Tense</text>
      <text x="${pl}" y="${hh-2}" fill="var(--ink3)" font-size="9">Calm</text>
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
  // sitting block highlight
  s+=`<rect x="${X(13.17)}" y="14" width="${X(15.83)-X(13.17)}" height="${base-14}" rx="6" fill="rgba(255,138,91,.14)" stroke="rgba(255,138,91,.5)" stroke-width="1" stroke-dasharray="3 3"/>`;
  act.forEach(([hr,v])=>{ const bw=(w-pl-pr)/15-3;
    s+=`<rect x="${X(hr)-bw/2}" y="${base-v*58}" width="${bw}" height="${v*58}" rx="3" fill="rgba(220,245,90,${0.25+v*0.65})"/>`;});
  // energy line
  const en=[[8,5],[10,4],[12,4],[14,2],[16,2],[18,3],[20,3]];
  const Ye=v=>base-8-(v-1)/4*46;
  s+=`<path d="${smoothPath(en.map(([hr,v])=>[X(hr),Ye(v)]))}" stroke="#fff" stroke-width="1.6" opacity=".7" fill="none" stroke-dasharray="1 0"/>`;
  s+=`<circle cx="${X(14)}" cy="${Ye(2)}" r="3.4" fill="var(--coral)"/>
      <text x="${X(14)+7}" y="${Ye(2)+3}" fill="var(--coral)" font-size="9">rated 2</text>`;
  [7,12,17,21].forEach(hr=>{ s+=`<text x="${X(hr)}" y="${h-10}" fill="rgba(255,255,255,.35)" font-size="9" text-anchor="middle">${hr}:00</text>`;});
  s+=`<text x="${X(14.5)}" y="10" fill="rgba(255,138,91,.9)" font-size="9" text-anchor="middle">sitting 2 h 40 m</text>`;
  return s+'</svg>';
}
function devRow(name,value,pos,bandLo,bandHi){
  const inBand=pos>=bandLo&&pos<=bandHi, c=inBand?'var(--lime)':'var(--coral)';
  return `<div class="row" style="gap:12px;padding:9px 0">
    <div style="width:70px;font-size:12px;color:var(--onD2)">${name}</div>
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
  return `<div class="qualifier"><div class="h">Caveat · ${head}</div><div class="b">${body}</div>
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
    ${cardHead('recover','Recovery load',`${RANGES[S.range].t} window · vs ${RANGES[S.range].base}`)}
    <div class="row" style="align-items:flex-end;gap:10px;margin-top:14px">
      <div class="num" style="font-size:46px;line-height:1">${day.rec}</div>
      <div style="flex:1"><div style="font-size:11px;color:var(--onD3)">out of 100</div>
        <div style="font-size:12.5px;font-weight:600;color:var(--coral)">Load is high</div></div>
      <div style="text-align:right"><div style="font-size:10.5px;color:var(--onD3)">vs baseline</div>
        <div class="num" style="font-size:16px;color:var(--coral)">+${day.rd}</div></div></div>
    <div style="margin-top:10px;position:relative">${stressTide(day.rec/100)}
      <div style="position:absolute;left:0;bottom:0;font-size:9.5px;color:var(--onD3)">baseline 47</div></div>
    <div class="hair-d" style="margin-top:12px"></div>
    ${devRow('Sleep',day.sleep,(Mock.hm(day.sleep)-5.5)/2.5,0.58,0.95)}
    ${devRow('Heart rate variability',day.hrv+' ms',(day.hrv-34)/22,0.45,0.9)}
    ${devRow('Resting heart rate',day.rhr+' bpm',(day.rhr-54)/12,0.08,0.58)}
  </div></div>`;
}
function nightCardHTML(day,compact=false){
  const mins=h=>{const m=Math.round(h*60);return `${Math.floor(m/60)}h${String(m%60).padStart(2,'0')}m`;};
  const deep=mins(Mock.hm(day.sleep)*0.20), rem=mins(Mock.hm(day.sleep)*0.25);
  return `<div class="fog warm"><div class="bg"></div><div class="pad">
    ${cardHead('moon','Last night',`${day.date} · Apple Watch`, day.wk>=3?'Fragmented':'Continuous', day.wk>=3?'warn':'good')}
    <div class="row" style="justify-content:space-between;align-items:baseline;margin-top:13px">
      <span class="num" style="font-size:36px">${day.sleep}</span>
      <span style="font-size:12.5px;font-weight:600;color:var(--coral)">↓ ${Math.abs(day.sd)} min</span></div>
    <div style="font-size:10.5px;color:var(--onD3);margin-top:4px">baseline 7:28 · prev 28 days · Excluded 10/10</div>
    <div style="margin-top:12px">${sleepAxis(day)}</div>
    ${statTrio([{v:deep,k:'Deep 20%'},{v:rem,k:'REM 25%'},{v:`${day.wk} × · ${day.am}m`,k:'Awakenings'}])}
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
    case 'recap':   html=vRecap(); break;
    case 'profile': html=vProfile(); break;
    case 'medical': html=vMedical(); break;
    case 'main':    html=vMain(); break;
  }
  $screen.innerHTML=html;
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
      <span style="font-size:10px;font-weight:600;letter-spacing:.6px;color:rgba(255,255,255,.75);
            padding:5px 9px;border-radius:99px;background:rgba(255,255,255,.1);border:1px solid rgba(255,255,255,.14)">Early access</span></div>
    <div style="flex:1 0 10px;max-height:26px"></div>
    <div class="appearup" style="position:relative;padding-right:56px">
      <div class="glass" style="border-radius:20px;padding:14px">
        <div class="row" style="gap:8px"><span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
          <span style="font-size:9px;font-weight:700;letter-spacing:1.4px;color:rgba(255,255,255,.55)">CORTISOL · ONE DAY</span>
          <span style="margin-left:auto;font-size:9px;color:rgba(255,255,255,.35)">ng/mL</span></div>
        <div style="margin-top:10px">${cortisolSketch()}</div>
        <div class="row" style="gap:4px;margin-top:10px">
          ${['Depleted','Balanced','Activated','Tense','Over'].map((s,i)=>`<div style="flex:1;text-align:center">
            <div style="height:3px;border-radius:99px;background:${i===3?'var(--lime)':'rgba(255,255,255,.16)'}"></div>
            <div style="font-size:7.5px;margin-top:5px;color:${i===3?'#fff':'rgba(255,255,255,.3)'};${i===3?'font-weight:700':''}">${s}</div></div>`).join('')}</div>
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
          <div style="font-size:9px;color:rgba(255,255,255,.45)">Sleep</div></div></div>
    </div>
    <div style="flex:1 0 10px;max-height:28px"></div>
    <div class="serif appearup" style="font-size:38px;font-weight:600;letter-spacing:-1.2px;color:#fff;line-height:1.08">Stress isn't<br>a feeling.</div>
    <div class="serif appearup" style="font-size:38px;font-style:italic;letter-spacing:-1.2px;color:var(--lime);line-height:1.15">It has a shape.</div>
    <p class="appearup" style="font-size:12.5px;color:rgba(255,255,255,.58);line-height:1.55;margin-top:10px">
      Aira reads your sleep, heart rate and salivary cortisol together — then names the state your body is in, and what still can't be known.</p>
    <div style="flex:1 0 8px;max-height:22px"></div>
    <div style="display:flex;flex-direction:column;gap:13px">
      ${[['Your wearables','Apple Health, Oura, WHOOP — last 30 days',
          `<span style="position:relative;width:88px;height:36px;display:inline-block">
            <img src="Assets/appicon_whoop.png" style="position:absolute;left:46px;top:3px;width:30px;border-radius:8px;transform:rotate(10deg)">
            <img src="Assets/appicon_oura.png" style="position:absolute;left:26px;top:-2px;width:31px;border-radius:8px;transform:rotate(-3deg)">
            <img src="Assets/appicon_health.png" style="position:absolute;left:4px;top:2px;width:33px;border-radius:8px;transform:rotate(-9deg);box-shadow:0 3px 8px rgba(0,0,0,.3)">
          </span>`],
         ['A saliva sample','Five tubes in one day, at home',
          `<span style="width:88px;display:flex;justify-content:center">
            <span style="width:40px;height:40px;border-radius:10px;background:#f2f4ea;display:flex;align-items:center;justify-content:center;transform:rotate(-5deg);box-shadow:0 3px 8px rgba(0,0,0,.25)">${ic('drop',22,1.8,'#7a8f3a')}</span></span>`],
         ['One joint read','Your state, your plan, and the open questions',
          `<span style="width:88px;display:flex;justify-content:center">
            <span style="width:40px;height:40px;border-radius:10px;background:#f4f2ec;display:flex;align-items:center;justify-content:center;transform:rotate(4deg);box-shadow:0 3px 8px rgba(0,0,0,.25)">${ic('plan',22,1.6,'#5d6b2f')}</span></span>`]
       ].map((r,i)=>`<div class="row appearup" style="gap:14px;animation-delay:${0.18+i*0.09}s">${r[2]}
          <div><div style="font-size:13.5px;font-weight:600;color:#fff">${r[0]}</div>
          <div style="font-size:11px;color:rgba(255,255,255,.48)">${r[1]}</div></div></div>`).join('')}
    </div>
    <div style="margin-top:16px">${cta('Get started','data-act="getstarted"')}</div>
    <div style="text-align:center;font-size:10.5px;color:rgba(255,255,255,.32);margin-top:10px">Aira is not a medical device. For wellness guidance only.</div>
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
  const types=[['moon','Sleep analysis','Duration, stages, awakenings'],
    ['pulse','Heart rate variability','The core recovery signal'],
    ['pulse','Resting heart rate','Read with HRV — never alone'],
    ['steps','Steps & activity','The load side of the balance'],
    ['breath','Respiratory rate','Side evidence for illness']];
  const wearables=[['appicon_oura','Oura Ring'],['appicon_whoop','WHOOP'],['appicon_garmin','Garmin']];
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(0,3,'data-act="phase" data-v="welcome"')}
    <h2>Connect your data</h2>
    <div class="sub">Read-only. Aira imports the last 30 days so your first read already has a baseline to compare against.</div>
    <div class="body">
      <button class="wcard ${S.healthGranted?'on':''}" data-act="grant" style="display:flex;align-items:center;gap:13px;width:100%;padding:15px;text-align:left">
        <img src="Assets/appicon_health.png" style="width:48px;border-radius:12px">
        <div style="flex:1"><div style="font-size:15px;font-weight:600">Apple Health</div>
          <div style="font-size:11.5px;color:${S.healthGranted?'var(--ink2)':'var(--ink3)'}">
            ${S.healthGranted?'Connected · 5 data types':'Required — this is where the signal comes from'}</div></div>
        ${S.healthGranted?`<span style="width:28px;height:28px;border-radius:50%;background:var(--lime);display:flex;align-items:center;justify-content:center">${ic('check',15,2.4,'var(--ink)')}</span>`:''}
      </button>
      ${S.healthGranted?`<div class="wcard fadein" style="margin-top:14px;padding:4px 0">
        ${types.map((t,i)=>`<div class="row" style="gap:12px;padding:9px 14px;${i?'border-top:1px solid var(--hair)':''}">
          <span style="width:32px;height:32px;border-radius:10px;background:var(--hair2);display:flex;align-items:center;justify-content:center">${ic(t[0],17,1.8,'var(--ink2)')}</span>
          <div style="flex:1"><div style="font-size:13.5px;font-weight:500">${t[1]}</div>
            <div style="font-size:11px;color:var(--ink3)">${t[2]}</div></div>
          ${ic('check',13,2.2,'var(--ink3)')}</div>`).join('')}</div>`:''}
      <div style="font-size:12.5px;font-weight:600;color:var(--ink2);margin:16px 0 9px">Add a wearable (optional)</div>
      <div class="row" style="gap:9px">
        ${wearables.map(([img,name])=>`<button class="wcard ${S.devices.has(name)?'on':''}" data-act="device" data-v="${name}"
           style="flex:1;padding:13px 4px;display:flex;flex-direction:column;align-items:center;gap:7px;border-radius:17px">
          <img src="Assets/${img}.png" style="width:38px;border-radius:10px">
          <span style="font-size:10.5px;color:${S.devices.has(name)?'var(--ink)':'var(--ink3)'};${S.devices.has(name)?'font-weight:600':''}">${name}</span></button>`).join('')}</div>
      <div class="row" style="gap:9px;align-items:flex-start;margin-top:16px">
        ${ic('info',13,1.8,'var(--ink3)','margin-top:2px')}
        <span style="font-size:11.5px;color:var(--ink3);line-height:1.5">No watch? iPhone's own sleep and step data works — Aira just marks the lower precision in every conclusion drawn from it.</span></div>
    </div>
    <div class="foot">${cta(S.healthGranted?'Import last 30 days':'Connect Apple Health','data-act="connectnext"')}</div>
  </div></div>`;
}

/* ---- 3 Syncing ---- */
function vSyncing(){
  const items=['Sleep analysis · 30 days','Heart rate variability · 30 days','Resting heart rate · 30 days','Steps & activity · 30 days'];
  return `<div class="view"><div class="fogscreen warm"></div>
  <div style="position:relative;display:flex;flex-direction:column;align-items:stretch;justify-content:center;height:100%;padding:0 26px;color:#fff">
    ${textSphere(180,52)}
    <div class="serif" style="font-size:21px;font-weight:600;letter-spacing:-.4px;text-align:center;margin-top:18px">Reading your last 30 days</div>
    <div class="glass" style="border-radius:22px;padding:18px;margin-top:24px;display:flex;flex-direction:column;gap:12px">
      ${items.map((s,i)=>`<div class="row" style="gap:10px">
        <span id="sync-dot-${i}" style="width:16px;height:16px;border-radius:50%;flex:none;display:flex;align-items:center;justify-content:center;
          ${i<S.syncedItems?'background:var(--lime)':'border:1.4px solid rgba(255,255,255,.2)'}">
          ${i<S.syncedItems?ic('check',9,2.6,'var(--ink)'):''}</span>
        <span id="sync-txt-${i}" style="font-size:13px;color:${i<S.syncedItems?'#fff':'rgba(255,255,255,.35)'}">${s}</span></div>`).join('')}
    </div>
    <div id="syncbar" style="margin:22px 28px 0">${neonBar(S.syncedItems/4*100)}</div>
    <div style="position:absolute;bottom:max(30px, env(safe-area-inset-bottom));left:0;right:0;text-align:center;
         font-size:11px;color:rgba(255,255,255,.34)">Data moves only between your device and Aira's encrypted store.</div>
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
    ${sectionLabel('From synced data · Oct 7 – 13')}
    <div class="serif" style="font-size:28px;font-weight:600;letter-spacing:-.6px;line-height:1.18;margin-top:6px">There's already<br>something to see</div>
    <div style="font-size:13.5px;color:var(--ink2);line-height:1.5;margin-top:6px">No need to wait for saliva — your last 7 days of sleep and heart rate already say part of it.</div>
    <div style="display:flex;flex-direction:column;gap:14px;margin-top:14px;padding-bottom:12px">
      ${recoveryCardHTML()}
      ${nightCardHTML(day)}
      <div class="fog warm"><div class="bg"></div><div class="pad">
        ${cardHead('spark',"Aira's first read",'Device data × your own words')}
        <div style="font-size:19px;font-weight:600;letter-spacing:-.5px;margin-top:12px">It's not that you slept less — you slept broken.</div>
        <div style="font-size:13.5px;color:var(--onD2);line-height:1.55;margin-top:8px">Total is 64 min below baseline, but the night broke into 5 pieces with the longest only 2 hours. Deep sleep accumulates in long blocks — which matches you waking up tired.</div>
        ${qualifier("That's as far as I can go","Sleep and heart rate show recovery load rose, but not why. Night caregiving and a work crunch overlap, and the data can't separate them.")}
      </div></div>
      <div class="fog flat"><div class="bg"></div><div class="pad">
        ${cardHead('drop','What saliva adds',"Three questions device data can't answer")}
        <div style="display:flex;flex-direction:column;gap:13px;margin-top:13px">
        ${[["Can't get going, or simply short on sleep","The rise across the two morning points (CAR) tells them apart"],
           ["How badly you can't switch off at night","The before-bed tube is the one point where all five states separate"],
           ["Too much drain, or too little repair","DHEA and the testosterone/cortisol ratio point to different interventions"]]
          .map((p,i)=>`<div class="row" style="gap:11px;align-items:flex-start">
            <span style="font-size:10px;font-weight:700;color:var(--lime);width:18px;padding-top:2px">0${i+1}</span>
            <div><div style="font-size:13.5px;font-weight:600">${p[0]}</div>
              <div style="font-size:12px;color:var(--onD2);line-height:1.45;margin-top:3px">${p[1]}</div></div></div>`).join('')}
        </div></div></div>
    </div></div>
  <div style="padding:10px 20px max(20px, env(safe-area-inset-bottom))">
    ${cta('Continue','data-act="phase" data-v="profile"')}
    <button class="ghost-link" data-act="skiphome">Skip setup, go to Home</button></div>
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
  const title=step===0?'A little about you':'Do you train?';
  const sub=step===0?'Name, age and sex at birth — they set which reference ranges your results are read against.'
                    :'Training load changes how recovery data gets read — and what the plan dares to ask of you.';
  let body='';
  if(step===0){
    body=`<div style="display:flex;flex-direction:column;gap:20px;padding-top:6px">
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">What should Aira call you?</span></div>
        <input id="nick" class="serif" value="${S.nickname.replace(/"/g,'&quot;')}" placeholder="Chloe"
          style="width:100%;background:#fff;border:1px solid var(--hair);border-radius:18px;padding:15px 17px;
                 font-size:22px;font-weight:600;letter-spacing:-.5px"></div>
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">Age</span>
          <span style="font-size:11px;color:var(--ink3)">Reference ranges shift by decade</span></div>
        ${ruler('age',S.age,13,90,'years old')}</div>
      <div><div class="row" style="gap:7px;margin-bottom:9px"><span style="font-size:14px;font-weight:600">Sex at birth</span>
          <span style="font-size:11px;color:var(--ink3)">Cortisol and DHEA ranges differ</span></div>
        <div class="seg">${['Female','Male','Rather not say'].map((o,i)=>
          `<button class="${S.sex===i?'on':''}" data-act="sex" data-v="${i}">${o}</button>`).join('')}</div>
        ${S.sex===2?`<div class="row" style="gap:8px;align-items:flex-start;margin-top:10px">${ic('info',12,1.9,'var(--ink3)','margin-top:2px')}
          <span style="font-size:11.5px;color:var(--ink3);line-height:1.5">Aira will use the wider combined range — conclusions carry slightly larger uncertainty bands.</span></div>`:''}
      </div></div>`;
  } else {
    const freqs=[['None','moon'],['1–2','run'],['3–4','run'],['5+','run']];
    body=`<div style="display:flex;flex-direction:column;gap:16px;padding-top:10px">
      <div style="font-size:13px;font-weight:600">Sessions per week</div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:9px">
        ${freqs.map((f,i)=>`<button class="wcard ${S.sessionBand===i?'':''}" data-act="band" data-v="${i}"
          style="padding:17px 4px;border-radius:17px;display:flex;flex-direction:column;align-items:center;gap:5px;
          ${S.sessionBand===i?'background:var(--ink);color:#fff;border-color:var(--ink)':''}">
          ${ic(f[1],18,1.9,S.sessionBand===i?'#fff':'var(--ink2)')}
          <span style="font-size:14px;${S.sessionBand===i?'font-weight:600':'font-weight:500'}">${f[0]}</span></button>`).join('')}</div>
      ${S.sessionBand>0?`<div class="fadein"><div style="font-size:13px;font-weight:600;margin:8px 0 10px">For how long?</div>
        ${ruler('years',S.years,0,30,'years training')}</div>`:''}
    </div>`;
  }
  const ctaOk = step!==0 || true;
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(1,3, step===0?'data-act="phase" data-v="recap"':'data-act="profstep" data-v="0"')}
    <h2>${title}</h2><div class="sub">${sub}</div>
    <div class="body">${body}</div>
    <div class="foot">${cta(step===0?'Continue':'Looks right', step===0?'data-act="profstep" data-v="1"':'data-act="phase" data-v="medical"')}</div>
  </div></div>`;
}

/* ---- 6 Health background ---- */
const INJURIES=[['〰','Lower back','Caps load on the exercise side'],
  ['⌐','Knee','Swaps running for low-impact work'],
  ['⌙','Shoulder','Affects overhead and pressing volume'],
  ['∟','Achilles','Rules out plyometrics and sprints']];
const MEDS=[['⚗','Corticosteroids','Directly raises measured cortisol'],
  ['◑','Contraceptives / hormones','Shifts the reference range used'],
  ['B7','Biotin (vitamin B7)','Interferes with the saliva assay'],
  ['▭','Antidepressants','Can flatten the morning rise'],
  ['≋','Inhaled steroids','Needs a mouth rinse before sampling']];
function medGroup(title,rows,set,act){
  return `<div><div class="row" style="margin-bottom:9px"><span style="font-size:14px;font-weight:600">${title}</span>
    ${set.size?`<span style="margin-left:auto;font-size:11px;color:var(--ink3)">${set.size} selected</span>`:''}</div>
   <div class="rowlist">${rows.map(r=>{
     const on=set.has(r[1]);
     return `<button class="rowitem ${on?'on':''}" data-act="${act}" data-v="${r[1].replace(/"/g,'&quot;')}">
       <span class="ric" style="font-size:${r[0].length>1?'12px':'17px'};font-weight:700;color:${r[0]==='B7'?'var(--amber)':'var(--ink)'}">${r[0]}</span>
       <span class="rt"><span class="a" style="display:block">${r[1]}</span><span class="b" style="display:block">${r[2]}</span></span>
       <span class="box">${on?ic('check',11,2.6,'#fff'):''}</span></button>`;}).join('')}</div></div>`;
}
function vMedical(){
  return `<div class="view" style="background:var(--page)"><div class="onb">
    ${onbTop(2,3,'data-act="phase" data-v="profile"')}
    <h2>Anything we should know?</h2>
    <div class="sub">Each one changes how a result gets read. Skip whatever doesn't apply.</div>
    <div class="body"><div style="display:flex;flex-direction:column;gap:22px">
      ${medGroup('Injury history',INJURIES,S.injuries,'injury')}
      ${medGroup('Medication & supplements',MEDS,S.meds,'med')}
      ${S.meds.has('Biotin (vitamin B7)')?`<div class="fadein row" style="gap:11px;align-items:flex-start;padding:14px;
          border-radius:17px;background:rgba(220,245,90,.45)">
        <span style="width:34px;height:34px;border-radius:10px;background:#fff;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:12px;color:var(--amber)">B7</span>
        <div><div style="font-size:13px;font-weight:600">We'll move your sampling day</div>
          <div style="font-size:11.5px;color:var(--ink2);line-height:1.5;margin-top:3px">Biotin has to be off for 48 h before the first tube or the assay reads high. Aira will schedule around it.</div></div></div>`:''}
    </div></div>
    <div class="foot">${cta('Continue','data-act="finishonb"')}
      <button class="ghost-link" data-act="noneapply">None of these apply</button></div>
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
    <button class="${S.tab===0?'active':''}" data-act="tab" data-v="0">${ic('home',21,S.tab===0?2.1:1.7)}<span>Home</span></button>
    <button class="aira ${S.tab===1?'active':''}" data-act="tab" data-v="1">
      <span class="orb">${ic('spark',22,2,S.tab===1?'var(--ink)':'#fff')}
        ${S.unread>0&&S.tab!==1?'<span class="unread"></span>':''}</span></button>
    <button class="${S.tab===2?'active':''}" data-act="tab" data-v="2">${ic('plan',21,S.tab===2?2.1:1.7)}<span>Plan</span></button>
  </div></div>`;
}

/* ---- Home tab ---- */
function vHome(){
  const day=Mock.days[S.dayIndex], isToday=S.dayIndex===Mock.days.length-1, hasData=day.sleep!=='—';
  return `<div class="scroll" style="padding:0 16px 110px;padding-top:max(14px, env(safe-area-inset-top))">
    <div class="shell">
      <div class="row" style="padding:0 4px;gap:12px">
        <div style="flex:1"><div style="font-size:12.5px;color:var(--ink3)">Tue, Oct 14</div>
          <div style="font-size:21px;font-weight:600;letter-spacing:-.6px;margin-top:3px">Good morning, ${nick()}</div></div>
        <img src="Assets/avatar.jpg" style="width:48px;height:48px;border-radius:50%;object-fit:cover;
             border:2px solid rgba(255,255,255,.9);box-shadow:0 3px 8px rgba(0,0,0,.25)"></div>
      <div class="fog warm" style="border-radius:24px;margin-top:16px"><div class="bg"></div><div class="pad" style="padding:18px">
        <div class="row" style="align-items:flex-start">
          <div class="cardhead" style="flex:1"><div class="ibadge">${ic('recover',16,1.7,'#fff')}</div>
            <div class="tt"><div class="a" style="font-size:16px;font-weight:500">Recovery load</div>
              <div class="b">Recent · 7-day window</div></div></div>
          <div style="text-align:right"><span class="num" style="font-size:19px">47</span>
            <span style="font-size:11px;color:var(--onD2)"> / baseline</span>
            <div style="font-size:10px;color:var(--onD3)">prev 28 days</div></div></div>
        <div class="row" style="align-items:baseline;gap:5px;margin-top:10px">
          <span class="num" style="font-size:42px">${day.rec||60}</span>
          <span style="font-size:15px;color:var(--onD2)">/ 100</span>
          <span style="margin-left:auto;font-size:12.5px;font-weight:600;color:${(day.rec||60)>=58?'var(--coral)':'var(--lime)'}">
            ${(day.rec||60)>=58?'Load is high':(day.rec||60)>=45?'Mild buildup':'Well recovered'}</span></div>
        <div class="row" style="justify-content:space-between;margin-top:8px;font-size:11px;color:var(--onD3)"><span>0</span><span>100</span></div>
        <div style="margin-top:6px">${comb(34,(day.rec||60)/100,30)}</div>
        <div class="row" style="gap:8px;margin-top:20px;align-items:flex-start">
          ${[[Mock.avgSleepText(7),'','Sleep · 7-day avg'],[Math.round(Mock.avg(7,d=>d.hrv)),'ms','HRV · 7-day avg'],
             [Math.round(Mock.avg(7,d=>d.rhr)),'bpm','RHR · 7-day avg']].map(x=>`<div style="flex:1">
            <span class="num" style="font-size:24px;letter-spacing:-.8px">${x[0]}</span>
            ${x[1]?`<span style="font-size:12px;color:var(--onD2)"> ${x[1]}</span>`:''}
            <div style="font-size:11px;color:var(--onD3);margin-top:3px">${x[2]}</div></div>`).join('')}</div>
      </div></div>
      <div class="row" style="gap:5px;margin-top:18px;padding:0 4px">
        ${RANGES.map((r,i)=>`<button data-act="range" data-v="${i}" style="padding:7px 13px;border-radius:99px;font-size:12px;
          ${S.range===i?'background:var(--ink);color:#fff;font-weight:600':'background:var(--hair2);color:var(--ink2)'}">${r.t}</button>`).join('')}
        <span style="margin-left:auto;font-size:10.5px;color:var(--ink3)">${RANGES[S.range].grain}</span></div>
      <div style="margin-top:8px">${sleepScrubber()}</div>
      <div style="margin-top:14px">
        <div class="row" style="padding:0 4px">
          <div style="flex:1"><div style="font-size:13.5px;font-weight:600">How you've felt</div>
            <div style="font-size:10.5px;color:var(--ink3)">${S.loggedToday?`Logged ${faceNames[S.feel]} today`:'No check-in yet today'}</div></div>
          <button data-act="sheet" data-v="checkin" style="display:flex;align-items:center;gap:6px;padding:8px 12px;
            border-radius:99px;background:var(--ink);color:#fff;font-size:12px;font-weight:600">
            ${ic(S.loggedToday?'refresh':'plus',12,2.2,'#fff')} ${S.loggedToday?'Edit':'Check in'}</button></div>
        <div style="margin-top:2px">${selfTrend()}</div></div>
    </div>
    <div style="display:flex;flex-direction:column;gap:14px;margin-top:14px;padding:0 4px">
      ${hasData?nightCardHTML(day):`<div class="fog flat"><div class="bg"></div><div class="pad">
        ${cardHead('info','No data this day',`${day.date} · ${day.wd}`,'Excluded','off')}
        <div style="font-size:14px;margin-top:13px">The watch wasn't worn, or didn't sync.</div>
        <div style="font-size:12.5px;color:var(--onD2);line-height:1.5;margin-top:6px">Excluded from the 7-day average — so the "7-day mean" is based on 6 days.</div></div></div>`}
      ${isToday&&hasData?`<div class="fog warm"><div class="bg"></div><div class="pad">
        ${cardHead('clock','Yesterday','Activity × Energy · 10/13','Afternoon dip','warn')}
        <div style="font-size:15px;font-weight:600;letter-spacing:-.3px;line-height:1.45;margin-top:12px">Yesterday's sitting block<br>landed right on your energy low.</div>
        <div style="margin-top:8px">${dayRibbon()}</div>
        ${statTrio([{v:'8,260',k:'Steps'},{v:'13:10',k:'Sitting began'},{v:'rated 2',k:'Energy at 14:00'}])}</div></div>`:''}
      <button data-act="sheet" data-v="testing" style="text-align:left;width:100%">
        <div class="fog flat"><div class="bg"></div><div class="pad">
          ${cardHead('drop',salivaTitle(),'First saliva test', S.saliva===2?donePts()+'/5':null, 'good',
             `<span style="color:var(--onD3)">${ic('chevron',13,2,'currentColor')}</span>`)}
          <div style="font-size:13px;color:var(--onD2);line-height:1.5;margin-top:11px">${salivaSub()}</div>
          ${S.saliva===2||S.saliva===3?`<div style="margin-top:12px">${comb(5,donePts()/5,18)}</div>`:''}
        </div></div></button>
    </div></div>`;
}
function salivaTitle(){
  return ['Saliva · not scheduled','Saliva · starts tomorrow','Saliva · in progress','Shipped · at the lab','Saliva report ready'][S.saliva];
}
function salivaSub(){
  return ["We still can't say why recovery load is up. Salivary cortisol separates an HPA-axis problem from plain sleep debt.",
    'First tube within 30 min of waking. Stop biotin supplements starting tonight.',
    `Next tube ${(S.points.find(p=>!p.done)||{}).when||''} · ${(S.points.find(p=>!p.done)||{}).name||''}`,
    'Results usually take 5–7 business days, then we read them against these weeks of sleep.',
    "HPA axis: Strained. Can't get going in the morning, can't switch off at night."][S.saliva];
}

/* ---- Agent tab ---- */
function vAgent(){
  const stageLine=['Tracking · recovery load, 7d','Tracking · collection starts tomorrow',
    `Tracking · collecting ${donePts()}/5`,'Tracking · waiting on the lab','Tracking · report and plan'][S.saliva];
  const thread=buildThread();
  const primary = S.saliva===0 ? (S.sent.includes('Schedule for tomorrow')?null:'Schedule for tomorrow')
                : S.saliva===4 ? (S.sent.includes('Open full report')?null:'Open full report') : null;
  const ctxAll = S.saliva===0?['Why saliva?',"What's wrong with my sleep?",'Show me Home']
    : S.saliva<=2?['What should I avoid?','What if I miss a time point?','Progress?']
    : S.saliva===3?['How long will it take?','What can I do meanwhile?']
    : ["What does Strained mean?",'Why these three?'];
  const ctx=ctxAll.filter(c=>!S.sent.includes(c));
  return `<div style="display:flex;flex-direction:column;height:100%;color:#fff">
    <div style="text-align:center;padding-top:max(14px, env(safe-area-inset-top));position:relative;flex:none">
      <div style="width:46px;height:46px;border-radius:50%;background:rgba(255,255,255,.10);
        border:1px solid rgba(255,255,255,.18);margin:6px auto 0;display:flex;align-items:center;justify-content:center;position:relative">
        <span style="position:absolute;top:-4px;right:-4px;width:16px;height:16px;border-radius:50%;background:var(--lime);filter:blur(7px)"></span>
        ${ic('spark',20,1.9,'var(--lime)')}</div>
      <div class="row" style="justify-content:center;gap:4px;margin-top:5px">
        <span style="font-size:13.5px;font-weight:600">Aira</span>${ic('chevron',9,2.2,'rgba(255,255,255,.4)')}</div>
      <div style="font-size:10.5px;color:rgba(255,255,255,.42);margin-top:1px">${stageLine}</div>
      <button data-act="sheet" data-v="testing" style="position:absolute;right:16px;top:max(22px, env(safe-area-inset-top));
        width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.10);display:flex;align-items:center;justify-content:center">
        ${ic('drop',16,1.9,'rgba(255,255,255,.8)')}</button></div>
    <div style="display:flex;gap:7px;overflow-x:auto;scrollbar-width:none;padding:10px 16px;flex:none">
      ${ctxChip('recover','Recovery','60 · high',true)}
      ${ctxChip('moon','Sleep','6:31 ↓64m',true)}
      ${ctxChip('pulse','HRV','42 ms',false)}
      ${S.saliva===4?ctxChip('drop','HPA','Strained',true):ctxChip('drop','Saliva',['not scheduled','tomorrow',donePts()+'/5','at the lab','ready'][S.saliva],false)}
    </div>
    <div id="threadscroll" class="scroll" style="padding:4px 14px 10px">
      ${thread}
    </div>
    <div style="flex:none;padding:8px 0 90px">
      ${(primary||ctx.length)?`<div style="display:flex;gap:7px;overflow-x:auto;scrollbar-width:none;padding:0 16px 8px">
        ${primary?`<button class="replychip" data-act="send" data-v="${primary}" style="background:var(--lime);color:var(--ink);font-weight:600;flex:none">
          ${ic('spark',11,2.2,'var(--ink)')} ${primary}</button>`:''}
        ${ctx.map(c=>`<button class="replychip glass" data-act="send" data-v="${c.replace(/"/g,'&quot;')}" style="flex:none;font-size:12.5px">${c}</button>`).join('')}
      </div>`:''}
      <div class="row" style="gap:10px;padding:0 16px">
        <button data-act="sheet" data-v="checkin" style="width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.10);
          display:flex;align-items:center;justify-content:center;flex:none">${ic('plus',17,2,'rgba(255,255,255,.75)')}</button>
        <div class="row" style="flex:1;gap:8px;padding:5px 5px 5px 15px;border-radius:99px;background:rgba(255,255,255,.09);
             border:1px solid rgba(255,255,255,.13)">
          <input id="composer" placeholder="Message" style="flex:1;color:#fff;font-size:15px;min-width:0">
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
  let out=`<div class="stagemark" style="margin-top:8px">Tue, Oct 14</div>`;
  out+=bub('Your data is in. I looked at the last 7 days.');
  out+=`<div style="margin:10px 28px 0 2px">${nightCardHTML(Mock.days[12],true)}</div>`;
  out+=bub("It's not that you slept less — you slept broken.",true);
  out+=bub('Total is 64 min below baseline, but the night broke into 5 pieces and the longest was only 2 hours. Deep sleep accumulates in long blocks — which matches you waking up tired.',false,true);
  if(S.saliva===0){
    out+=`<div style="margin-right:34px">${qualifier("That's as far as I can go","Sleep and heart rate only show recovery load went up — not why. Night caregiving and a work crunch fell in the same window, and the data can't separate them.")}</div>`;
    out+=bub("Salivary cortisol can separate them — the morning rise tells us whether this is the HPA axis itself or plain sleep debt.");
  }
  for(const s of S.sent) out+=exchange(s);
  if(S.saliva>=1&&S.saliva<4){
    out+=`<div class="stagemark" style="margin-top:18px">Collection</div>`;
    if(S.saliva===1){
      out+=bub("Scheduled for tomorrow. First tube within 30 min of waking — I'll remind you at your usual wake time.");
      out+=bub('Stop biotin (vitamin B7) supplements starting tonight — it interferes with the assay.',false,true);
    } else if(S.saliva===2){
      const nx=S.points.find(p=>!p.done);
      out+=bub(`${donePts()} done. Next up: ${nx?nx.name:''} at ${nx?nx.when:''}.`);
    } else {
      out+=bub('All five tubes are in and shipped. Results usually take 5–7 business days.');
      out+=bub("I'll keep watching your sleep meanwhile. If onset steadies, we'll be able to tell which changes came from the intervention.",false,true);
    }
  }
  if(S.saliva===4){
    out+=`<div class="stagemark" style="margin-top:18px">Report</div>`;
    if(!S.sent.includes('Open full report')){
      out+=`<div class="glass" style="border-radius:24px;padding:18px 10px;margin-top:10px;text-align:center">
        ${textSphere(150,40)}
        <div class="shiny" style="font-size:12.5px;margin-top:10px">Running joint analysis on your saliva result and 30 days of wearable data</div>
        <div style="margin:12px 28px 0">${neonBar(62)}</div></div>`;
    }
    out+=bub('The report is in.');
    out+=bub("You're Strained — can't get going when you should, can't stop when you should.",true,true);
    out+=`<button data-act="sheet" data-v="report" style="display:block;width:calc(100% - 28px);margin:10px 28px 0 0;text-align:left">
      <div class="glass" style="border-radius:22px;padding:16px;color:#fff">
        <div class="cardhead"><div class="ibadge">${ic('breath',16,1.7,'#fff')}</div>
          <div class="tt"><div class="a">HPA axis</div><div class="b">Saliva · 10/15</div></div>
          ${chipEl('Slower regulation','warn')}</div>
        <div class="row" style="gap:7px;align-items:baseline;margin-top:11px">
          <span class="num" style="font-size:25px;color:var(--amber)">Tense</span>
          <span style="font-size:12.5px;color:rgba(255,255,255,.55)">Strained</span></div>
        <div style="margin-top:8px">${hpaDeviation(300,120)}</div>
        <div class="hair-d" style="margin:12px 0"></div>${stateStrip(3)}</div></button>`;
    out+=bub('The morning rise that should be there didn\'t happen (CAR 32%, expected >50%), and the afternoon and evening never came down (AUCg 33.3 vs 22.0 for Balanced). Both ends match what you told me.');
    out+=`<div style="margin-right:34px">${qualifier('Only one day','Only one day sampled. Balanced and Strained overlap on single-day data — add the +30 min and before-bed points to confirm.')}</div>`;
    out+=bub('I drafted three, ranked by impact. The first one works on both ends at once.');
    out+=`<div class="glass" style="border-radius:22px;padding:15px;margin:10px 28px 0 0;color:#fff">
      <div class="cardhead"><div class="ibadge">${ic('plan',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">Three actions drafted</div><div class="b">Swipe to accept or skip, over in Plan</div></div></div>
      <div style="display:flex;flex-direction:column;gap:7px;margin-top:11px">
        ${S.reportRecs.map(r=>`<div class="row" style="gap:9px;padding:8px 11px;border-radius:11px;background:rgba(255,255,255,.07)">
          <span class="num" style="font-size:12px;width:26px;color:${r.col}">${r.impact}</span>
          <span style="font-size:12.5px;font-weight:500;color:rgba(255,255,255,.88);flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.title}</span>
          ${r.state===1?ic('check',11,2.6,'var(--lime)'):''}</div>`).join('')}</div>
      <button data-act="tab" data-v="2" style="display:flex;align-items:center;justify-content:center;gap:7px;width:100%;
        margin-top:12px;padding:11px;border-radius:99px;background:var(--lime);color:var(--ink);font-size:12.5px;font-weight:600">
        Review in Plan ${ic('arrowRight',12,2.2,'var(--ink)')}</button></div>`;
  }
  return out;
}
function exchange(s){
  let out=userBub(s);
  const A={
    'Schedule for tomorrow':["Done. First tube at 06:45 tomorrow — I'll remind you. The step-by-step guide lives under Collection."],
    'Why saliva?':["Saliva is the only easy way to measure free cortisol — most of what's in blood is protein-bound and doesn't reflect current regulation. Saliva also lets you sample 5× a day; blood doesn't.",
      'Cortisol is strongly circadian — 10× between morning and night in the same person. One reading proves nothing; the daily shape does.'],
    "What's wrong with my sleep?":['Duration is 64 min short, but fragmentation matters more: 3 awakenings totalling 42 min, against a baseline of 1.2 and 13 min. The longest unbroken block is 2 hours — deep sleep can\'t accumulate.'],
    'Show me Home':['Sure. Home is organised by day — you can scrub back through the week.'],
    'What should I avoid?':['Three things: no food or coffee 30 min before, no brushing 10 min before, no exercise after waking. The time point matters more than precision — within 15 minutes is fine.'],
    'What if I miss a time point?':['Write the actual clock time on the label, not the planned one. I compute CAR from the real time — a wrong label makes it incomparable.'],
    'Progress?':[`${donePts()} of 5 done. Next tube ${(S.points.find(p=>!p.done)||{}).when||'—'}.`],
    'How long will it take?':["5–7 business days. You'll hear from me the moment it lands."],
    'What can I do meanwhile?':["Start with a fixed wake time. It doesn't depend on saliva, and it helps us attribute changes once the report lands."],
    "What does Strained mean?":["Can't get going when you should, can't stop when you should. The morning side means your body hasn't entered a ready state; the evening side means it stays on alert, which makes falling asleep harder."],
    'Why these three?':['Fixed wake time carries the highest weight (9.1) and is the only one acting on both ends — set the wake time and sleep onset drifts earlier on its own. The other two target the evening end and the afternoon trough.',
      "No supplement advice this round — the data can't support that call yet."],
    'Open full report':['Opened. Chapter three is entirely about what still can\'t be known this round.'],
  };
  const rs=A[s]||["That needs data you haven't synced yet. I have sleep, HRV, resting heart rate and activity — happy to go deeper on those. For hormones or metabolism, I'd rather wait for saliva."];
  rs.forEach((r,i)=>out+=bub(r,false,i>0));
  return out;
}
function send(s){
  if(S.sent.includes(s)) return;
  S.sent.push(s); S.unread=0;
  if(s==='Schedule for tomorrow'&&S.saliva<1) S.saliva=1;
  if(s==='Open full report'){ render(); openSheet('report'); return; }
  if(s==='Show me Home'){ S.tab=0; }
  render();
}

/* ---- Plan tab ---- */
function vPlan(){
  const hasReport=S.saliva===4;
  const dims=[['Sleep',true],['HRV',true],['RHR',true],['Activity',true],['Cortisol',hasReport],['DHEA',hasReport]];
  const accAll=accepted();
  const LIBW=[['walk','Brisk walk','Low intensity · best fit','#E9F4C6'],['run','Running','Mod–high','#F7DFE4'],
    ['bike','Cycling','Moderate','#DCE7F3'],['strength','Strength','High load','#F2EADA'],
    ['swim','Swimming','Full body · low impact','#DCEFE5'],['rope','Jump rope','High intensity · short','#E8E3F4']];
  const LIBR=[['meditate','Breathwork','Before bed · best fit','#E9F4C6'],['stretch','Stretching','After sitting','#DCEFE5'],
    ['walk','Walk','Afternoon','#DCE7F3'],['coffee','Coffee','Before 14:00','#F2EADA'],
    ['dance','Dancing','Just move','#F7DFE4'],['read','Reading','Instead of scrolling','#E8E3F4']];
  const lib=S.planSeg===0?LIBW:LIBR;
  return `<div class="scroll" style="padding:0 20px 110px;padding-top:max(14px, env(safe-area-inset-top))">
    <div class="row" style="align-items:flex-start;padding-top:14px">
      <div style="flex:1"><div style="font-size:12.5px;color:var(--ink3)">${hasReport?'Saliva biomarkers × device data':'From the last 7 days of device data'}</div>
        <div style="font-size:23px;font-weight:600;letter-spacing:-.7px;margin-top:3px">Your plan</div></div>
      <img src="Assets/avatar.jpg" style="width:40px;height:40px;border-radius:50%;object-fit:cover;border:2px solid #fff;box-shadow:0 3px 8px rgba(0,0,0,.2)"></div>
    <div style="margin-top:15px;padding:13px;border-radius:18px;background:rgba(243,243,241,.7)">
      <div class="row"><span style="font-size:9px;font-weight:700;letter-spacing:1.4px;color:var(--ink3)">WHAT AIRA CAN SEE</span>
        <span style="margin-left:auto;font-size:10.5px;font-weight:600;color:${hasReport?'var(--ink)':'var(--ink2)'}">${dims.filter(d=>d[1]).length} of 6 signals</span></div>
      <div class="row" style="gap:5px;margin-top:10px">
        ${dims.map(d=>`<span style="flex:1;display:flex;align-items:center;justify-content:center;gap:4px;padding:5px 2px;
          border-radius:99px;background:${d[1]?'#fff':'var(--hair2)'};${d[1]?'border:1px solid var(--hair)':''};
          font-size:9.5px;color:${d[1]?'var(--ink)':'var(--ink3)'};${d[1]?'font-weight:600':''};white-space:nowrap">
          ${d[1]?'<span style="width:5px;height:5px;border-radius:50%;background:var(--lime)"></span>':ic('lock',8,2.2,'var(--ink3)')}${d[0]}</span>`).join('')}</div>
      <div style="font-size:10.5px;color:var(--ink3);line-height:1.5;margin-top:10px">
        ${hasReport?'Saliva came back 10/21 — recommendations below now carry biomarker evidence.':'Working from device data. Saliva adds the two hormone signals — and sharper recommendations.'}</div></div>
    <div style="margin-top:15px">
      ${hasReport?`<div class="fog cool"><div class="bg"></div><div class="pad">
        ${cardHead('breath',"This round's target",'From report · chapter 01','Tense','warn')}
        <div style="font-size:17px;font-weight:600;letter-spacing:-.4px;margin-top:11px">Start with the "can't switch off at night" end.</div>
        <div style="font-size:13px;color:var(--onD2);line-height:1.55;margin-top:7px">It's the more movable end — a fixed wake time pulls onset earlier and the morning side usually follows. The other way round rarely works.</div>
      </div></div>`
      :`<div class="fog flat"><div class="bg"></div><div class="pad">
        ${cardHead('clock','Full plan waits on saliva','A few things work regardless','Test in progress','off')}
        <div style="font-size:13px;color:var(--onD2);line-height:1.55;margin-top:12px">Until saliva is back I can't tell whether the morning or the evening end matters more — and the interventions differ completely. The items below rely only on device data you already have.</div>
        <button data-act="sheet" data-v="testing" class="row" style="gap:7px;margin-top:12px;color:var(--lime);font-size:12px;font-weight:600;letter-spacing:.6px">
          Schedule collection ${ic('arrowRight',12,2,'var(--lime)')}</button></div></div>`}</div>
    <div class="row" style="margin-top:15px">
      ${sectionLabel(hasReport?'Ranked by impact · from the report':'For you today · from device data')}
      ${deck().length?`<span style="margin-left:auto;font-size:10.5px;font-weight:600;color:var(--ink3)">${deck().length} to sort</span>`:''}</div>
    <div style="margin-top:8px">${deckHTML()}</div>
    ${accAll.length||S.arranged.length?`<div style="margin-top:18px">${sectionLabel(`In your plan · ${accAll.length+S.arranged.length} items`)}
      <div style="display:flex;flex-direction:column;gap:9px;margin-top:9px">
      ${accAll.map((r,i)=>`<div class="row" style="gap:12px;padding:13px;border-radius:20px;background:#fff;border:1px solid var(--hair)">
        <span style="width:44px;height:44px;border-radius:13px;background:${r.col.replace(')',',0.3)').replace('var(--sky)','rgba(122,203,255,.3)').replace('var(--lime)','rgba(220,245,90,.4)').replace('var(--amber)','rgba(255,184,92,.3)').replace('var(--violet)','rgba(183,155,255,.3)')};
          display:flex;align-items:center;justify-content:center">${ic(r.saliva?'drop':'spark',18,2,'var(--ink)')}</span>
        <div style="flex:1;min-width:0"><div style="font-size:14.5px;font-weight:600;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.title}</div>
          <div style="font-size:11px;color:var(--ink3);white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.constraint}</div></div>
        <span style="display:flex;gap:3px">${[...Array(7)].map((_,k)=>`<i style="width:4px;height:16px;border-radius:99px;background:${k<r.done?'var(--ink)':'var(--hair)'}"></i>`).join('')}</span></div>`).join('')}
      ${S.arranged.map(a=>`<div class="row" style="gap:13px;padding:13px;border-radius:20px;background:#fff;border:1px solid var(--hair)">
        <span style="width:50px;height:50px;border-radius:14px;background:${a.tint};display:flex;align-items:center;justify-content:center">${ic(a.icon,24,1.7,'rgba(16,16,17,.8)')}</span>
        <div style="flex:1"><div style="font-size:15px;font-weight:600">${a.name}</div>
          <div style="font-size:11.5px;color:var(--ink3)">${a.time} · ${a.minutes} min</div></div>
        <span style="display:flex;gap:3px">${[...Array(7)].map((_,k)=>`<i style="width:4px;height:16px;border-radius:99px;background:${k<a.done?'var(--ink)':'var(--hair)'}"></i>`).join('')}</span></div>`).join('')}
      </div></div>`:''}
    <div style="margin-top:18px">${sectionLabel('Build your own')}</div>
    <div class="row" style="gap:6px;margin-top:9px">
      ${['Workout','Unwind'].map((s,i)=>`<button data-act="planseg" data-v="${i}" class="row" style="gap:6px;padding:10px 15px;border-radius:99px;
        ${S.planSeg===i?'background:var(--ink);color:#fff;font-weight:600':'background:#fff;border:1px solid var(--hair);color:var(--ink2)'};font-size:13px">
        ${ic(i===0?'run':'meditate',15,1.9,S.planSeg===i?'#fff':'var(--ink2)')} ${s}</button>`).join('')}</div>
    ${S.planSeg===0?`<div class="row" style="gap:9px;align-items:flex-start;margin-top:12px;padding:13px;border-radius:15px;background:rgba(220,245,90,.4)">
      ${ic('spark',13,2,'var(--ink)','margin-top:1px')}<span style="font-size:12.5px;color:var(--ink2);line-height:1.5">Recovery load is high right now. Don't add intensity this week — the two low-intensity options fit better.</span></div>`:''}
    <div style="display:flex;gap:11px;overflow-x:auto;scrollbar-width:none;margin:12px -20px 0;padding:0 20px 4px">
      ${lib.map(a=>{ const sel=S.arranged.some(x=>x.name===a[1]);
        return `<button class="acttile ${sel?'sel':''}" data-act="arrange" data-v="${a[1]}" data-icon="${a[0]}" data-sub="${a[2]}" data-tint="${a[3]}"
          style="background:${a[3]}"><span class="ai">${ic(a[0],26,1.6,'rgba(16,16,17,.8)')}</span>
          <span><span class="at" style="display:block">${a[1]}</span><span class="as" style="display:block;margin-top:2px">${a[2]}</span></span></button>`;}).join('')}</div>
    ${hasReport?`<div class="fog flat" style="margin-top:14px"><div class="bg"></div><div class="pad">
      <div style="font-size:11px;font-weight:600;letter-spacing:1.2px;text-transform:uppercase;color:var(--onD3)">Not this round</div>
      <div style="display:flex;flex-direction:column;gap:11px;margin-top:11px">
      ${["Supplements — current data can't support that call","More intensity — recovery load is already high",
         "Caffeine — wasn't verified at sampling; next round"].map(s=>`<div class="row" style="gap:8px;align-items:flex-start">
         ${ic('minus',11,2,'var(--onD3)','margin-top:3px')}<span style="font-size:12.5px;color:var(--onD2);line-height:1.5">${s}</span></div>`).join('')}
      </div></div></div>`:''}
    <button data-act="sheet" data-v="ask" class="row" style="gap:9px;width:100%;margin-top:14px;padding:15px 16px;
      border-radius:18px;background:#fff;border:1px solid var(--hair);text-align:left">
      ${ic('ask',15,2,'var(--ink)')}<span style="flex:1;font-size:14px;font-weight:500">Ask about this plan</span>
      ${ic('chevron',12,2,'var(--ink3)')}</button>
  </div>`;
}
function deckHTML(){
  const d=deck();
  if(!d.length){
    return `<div style="text-align:center;padding:26px;border-radius:22px;background:#fff;border:1px solid var(--hair)">
      <span style="width:44px;height:44px;border-radius:50%;background:rgba(220,245,90,.5);display:inline-flex;align-items:center;justify-content:center">${ic('check',18,2.4,'var(--ink)')}</span>
      <div style="font-size:14.5px;font-weight:600;margin-top:10px">All sorted</div>
      <div style="font-size:11.5px;color:var(--ink3);margin-top:3px">${accepted().length} in your plan${stage().filter(r=>r.state===2).length?` · ${stage().filter(r=>r.state===2).length} skipped`:''}</div>
      ${stage().filter(r=>r.state===2).length?`<button data-act="restoreskipped" style="margin-top:10px;font-size:12px;font-weight:600;
        padding:8px 14px;border-radius:99px;background:#fff;border:1px solid var(--hair)">Review skipped</button>`:''}</div>`;
  }
  const under=d.slice(1,3).map((r,i)=>`<div style="position:absolute;inset:0;transform:rotate(${i===0?2.4:-2}deg) translate(${i===0?7:-8}px, ${(i+1)*9}px);
      opacity:${1-(i+1)*0.16};z-index:${2-i};pointer-events:none">${recCard(r,false)}</div>`).join('');
  return `<div class="deckwrap" style="padding-bottom:${Math.min(d.length-1,2)*10+4}px">
    <div style="position:relative">
      ${under}
      <div id="topcard" class="deckcard" style="position:relative;z-index:3">${recCard(d[0],S.deckExpanded)}
        <div id="swipehints" style="position:absolute;inset:0;display:flex;align-items:center;justify-content:space-between;
             padding:0 12px;pointer-events:none;opacity:0;transition:opacity .15s">
          <span style="padding:7px 10px;border-radius:99px;background:rgba(0,0,0,.45);color:#fff;font-size:11px;font-weight:700">‹ Skip</span>
          <span style="padding:7px 10px;border-radius:99px;background:var(--lime);color:var(--ink);font-size:11px;font-weight:700">Add ›</span>
        </div></div></div>
    <div class="deck-dots">${stage().map(r=>`<i class="${r.state===1?'acc':r.state===2?'skp':''}"></i>`).join('')}</div>
    <div style="text-align:center;font-size:10px;color:var(--ink3);margin-top:8px">Drag the card → add to plan · ← skip · tap for the evidence</div></div>`;
}
function recCard(r,expanded){
  return `<div class="fog ${r.saliva?'cool':'flat'}" style="border-radius:22px"><div class="bg"></div><div class="pad" style="padding:18px">
    <div class="row" style="gap:10px;align-items:flex-start">
      ${r.impact?`<div style="width:44px;text-align:center"><div class="num" style="font-size:20px;color:${r.col}">${r.impact}</div>
        <div style="font-size:7.5px;font-weight:700;letter-spacing:1px;color:var(--onD3)">IMPACT</div></div>`:''}
      <div style="flex:1"><div class="row" style="gap:6px">
          <span style="font-size:9px;font-weight:700;letter-spacing:1px;text-transform:uppercase;padding:3px 7px;
            border-radius:99px;background:${r.col};color:var(--ink)">${r.tag}</span>
          ${r.saliva?`<span class="row" style="gap:3px">${ic('drop',9,2.2,'var(--lime)')}<span style="font-size:8px;font-weight:700;letter-spacing:.8px;color:var(--lime)">BIOMARKER</span></span>`:''}</div>
        <div style="font-size:17px;font-weight:600;letter-spacing:-.4px;margin-top:6px">${r.title}</div></div></div>
    <div class="row" style="gap:8px;align-items:flex-start;margin-top:12px">
      ${ic('spark',12,2,'var(--lime)','margin-top:2px')}
      <span style="font-size:12.5px;color:var(--onD2);line-height:1.5;${expanded?'':'display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden'}">${r.because}</span></div>
    ${expanded?`<div class="fadein" style="margin-top:12px"><div class="hair-d"></div>
      <div style="font-size:8.5px;font-weight:700;letter-spacing:1.4px;color:var(--onD3);margin-top:10px">BUILT ON</div>
      <div class="row" style="gap:6px;flex-wrap:wrap;margin-top:8px">${r.evidence.map(e=>`<span class="evchip"><span class="d"></span>${e}</span>`).join('')}</div>
      <div class="row" style="gap:7px;margin-top:10px">${ic('clock',11,2,'var(--onD3)')}
        <span style="font-size:11px;color:var(--onD2)">${r.timeline}</span></div></div>`:''}
    <div class="row" style="margin-top:9px">
      <span style="font-size:10.5px;color:var(--onD3);flex:1;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${r.constraint}</span>
      <button data-act="deckexpand" class="row" style="gap:4px;color:var(--lime);font-size:10.5px;font-weight:600;padding:4px 0 4px 10px">
        ${expanded?'Less':'Why this'} ${ic('chevron',8,2.4,'var(--lime)',`transform:rotate(${expanded?'-90deg':'90deg'})`)}</button></div>
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
    <span style="font-size:18px;font-weight:600;letter-spacing:-.4px;flex:1">${title}</span>
    <button data-act="closesheet" style="width:32px;height:32px;border-radius:50%;background:var(--hair2);
      display:flex;align-items:center;justify-content:center">${ic('close',12,2.3,'var(--ink2)')}</button></div>`;
}

/* -- Testing (saliva collection) -- */
function shTesting(){
  const status=['Not scheduled','Scheduled · tomorrow morning',`Collecting · ${donePts()} / 5`,'Shipped · at the lab','Report ready'][S.saliva];
  let body='';
  if(S.saliva===0){
    body=`<div class="fog cool"><div class="bg"></div><div class="pad">
      ${cardHead('drop','Five tubes, one day','At home · mailed to the lab','~15 min','sky')}
      <div style="font-size:17px;font-weight:600;letter-spacing:-.4px;margin-top:14px">Why five time points</div>
      <div style="font-size:13px;color:var(--onD2);line-height:1.55;margin-top:6px">Cortisol can differ 10× across one day. The shape is the measurement.</div>
      <div style="margin-top:10px">${fiveTubesCurve()}</div></div></div>
    <div class="fog flat"><div class="bg"></div><div class="pad">
      ${cardHead('info','Avoid on sampling day','Four things — all of them skew the assay')}
      <div style="display:flex;flex-direction:column;gap:11px;margin-top:12px">
      ${['No biotin (vitamin B7) for 24 h before','No food or coffee for 30 min before',
         'No brushing for 10 min before — gum bleeding contaminates the sample',
         "Don't exercise after waking — first tube within 30 min"].map(s=>`<div class="row" style="gap:10px;align-items:flex-start">
        <span style="width:18px;height:18px;border-radius:50%;background:rgba(255,138,91,.16);display:flex;align-items:center;justify-content:center;flex:none;margin-top:1px">${ic('close',9,2.4,'var(--coral)')}</span>
        <span style="font-size:13px;color:var(--onD2);line-height:1.45">${s}</span></div>`).join('')}</div></div></div>
    ${cta('Schedule for tomorrow','data-act="schedule"')}`;
  } else if(S.saliva===1||S.saliva===2){
    body=`<div class="fog warm"><div class="bg"></div><div class="pad">
      ${cardHead('drop',"Today's five tubes",'Oct 15',`${donePts()} / 5`,'good')}
      <div style="margin-top:14px">${comb(5,donePts()/5,22)}</div>
      <div style="font-size:11px;color:var(--onD3);margin-top:8px">Sample at each time point — within 15 minutes is fine.</div></div></div>
    <div style="display:flex;flex-direction:column;gap:9px">
    ${S.points.map((p,i)=>`<button data-act="point" data-v="${i}" class="row" style="gap:12px;padding:14px;border-radius:17px;
        background:#fff;border:1px solid ${p.done?'rgba(220,245,90,.9)':'var(--hair)'};text-align:left;width:100%">
      <span style="width:42px;height:42px;border-radius:50%;background:${p.done?'var(--lime)':'var(--hair2)'};
        display:flex;align-items:center;justify-content:center;flex:none">
        ${p.done?ic('check',14,2.4,'var(--ink)'):`<span class="num" style="font-size:9.5px;color:var(--ink2)">${p.when}</span>`}</span>
      <span style="flex:1"><span style="display:block;font-size:14px;font-weight:600">${p.name}</span>
        <span style="display:block;font-size:11.5px;color:var(--ink3);margin-top:2px">${p.hint}</span></span>
      ${p.done?'<span style="font-size:11.5px;color:var(--ink3)">Done</span>':ic('chevron',12,2.2,'var(--ink3)')}</button>`).join('')}</div>
    <button class="ghost-link" data-act="fastforward">Demo: skip ahead to the report</button>`;
  } else if(S.saliva===3){
    body=`<div class="fog flat"><div class="bg"></div><div class="pad">
      ${cardHead('plan','Shipped','Oct 15 · 18:20','Processing','off')}
      <div style="display:flex;flex-direction:column;gap:12px;margin-top:14px">
      ${[['All 5 tubes collected',1],['Shipped',1],['Lab processing',0],['Report generated',0]].map(s=>`<div class="row" style="gap:10px">
        <span style="width:16px;height:16px;border-radius:50%;${s[1]?'background:var(--lime)':'border:1.4px solid rgba(255,255,255,.2)'};
          display:flex;align-items:center;justify-content:center;flex:none">${s[1]?ic('check',9,2.6,'var(--ink)'):''}</span>
        <span style="font-size:13px;color:${s[1]?'#fff':'var(--onD3)'}">${s[0]}</span></div>`).join('')}</div>
      <div style="font-size:12px;color:var(--onD2);line-height:1.55;margin-top:14px">Results usually arrive in 5–7 business days. Aira will read them together with these weeks of sleep.</div></div></div>
    ${cta('Demo: report ready','data-act="fastforward"')}`;
  } else {
    body=`<div class="fog cool"><div class="bg"></div><div class="pad">
      ${cardHead('plan','Report ready','Collected 10/15 · issued 10/21','Tense','warn')}
      <div style="font-size:19px;font-weight:600;letter-spacing:-.5px;margin-top:13px">HPA axis: Tense</div>
      <div style="font-size:13.5px;color:var(--onD2);line-height:1.6;margin-top:7px">Can't get going in the morning, can't switch off at night — matching what you said about waking tired and falling asleep later.</div></div></div>
    ${cta('Open full report','data-act="openreport"')}
    ${S.retestScheduled?`<div class="row" style="gap:8px;padding:12px;border-radius:14px;background:rgba(220,245,90,.35)">
      <span style="width:22px;height:22px;border-radius:50%;background:var(--lime);display:flex;align-items:center;justify-content:center">${ic('check',13,2.4,'var(--ink)')}</span>
      <span style="font-size:12.5px;font-weight:500;color:var(--ink2)">Re-test scheduled · 10/24 + 10/25, same time points</span></div>`
    :`<button data-act="retest" style="width:100%;padding:13px;border-radius:99px;background:#fff;border:1.2px solid rgba(16,16,17,.75);
      font-size:13px;font-weight:600">Collect 2 more days — confirm the state</button>`}`;
  }
  return sheetHead('Saliva collection')+`
    <div class="row" style="gap:7px;padding:6px 20px 0">
      <span style="width:6px;height:6px;border-radius:50%;background:${S.saliva===0?'var(--ink3)':'var(--lime)'}"></span>
      <span style="font-size:12.5px;font-weight:500;color:var(--ink2)">${status}</span></div>
    <div class="scroll" style="padding:16px 20px 40px;display:flex;flex-direction:column;gap:16px">${body}</div>`;
}

/* -- Guidance (collection steps) -- */
const GSTEPS=[['Rinse with water','Rinse for 10 seconds and spit. No brushing, no mouthwash — both skew results.'],
  ['Wait 10 minutes','Let your mouth return to baseline. Nothing to eat or drink while you wait.'],
  ['Hold the swab for 2 minutes',"Under the tongue, don't chew. Saturated is enough — no effort needed."],
  ['Back in the tube, seal it','Drop the swab straight in without touching the tip, press the cap until it clicks.'],
  ['Label the time point','Write the time point and the actual clock time — a wrong label makes the result unusable.']];
function shGuidance(){
  const i=S.stepIndex, pt=S.activePoint!=null?S.points[S.activePoint]:null;
  return `<div style="position:relative;height:100%;display:flex;flex-direction:column;background:var(--page)">
    <div style="position:absolute;top:0;left:0;right:0;height:56%;overflow:hidden">
      <img src="Assets/guide${i+1}.png" style="width:100%;height:100%;object-fit:cover;object-position:top">
      <div style="position:absolute;inset:0;background:linear-gradient(180deg,transparent 45%,rgba(237,237,236,.65) 80%,var(--page) 100%)"></div></div>
    <div class="row" style="position:relative;padding:18px 22px 0">
      <span class="row" style="gap:7px;padding:7px 11px;border-radius:99px;background:rgba(255,255,255,.85)">
        <span style="width:6px;height:6px;border-radius:50%;background:var(--lime)"></span>
        <span style="font-size:12px;font-weight:600;color:var(--ink2)">${pt?pt.name:'Collection'}</span></span>
      <button data-act="closeguidance" style="margin-left:auto;width:34px;height:34px;border-radius:50%;background:rgba(255,255,255,.9);
        display:flex;align-items:center;justify-content:center">${ic('close',13,2.3,'var(--ink2)')}</button></div>
    <div style="flex:1"></div>
    <div style="position:relative;padding:0 22px max(20px, env(safe-area-inset-bottom))">
      <div class="kicker">STEP ${i+1} OF 5</div>
      <div class="serif" style="font-size:28px;font-weight:600;letter-spacing:-.6px;margin-top:8px">${GSTEPS[i][0]}</div>
      <div style="font-size:13.5px;color:var(--ink2);line-height:1.6;margin-top:10px">${GSTEPS[i][1]}</div>
      ${i===1?`<div class="row" style="gap:8px;margin-top:14px;padding:9px 12px;border-radius:99px;background:rgba(220,245,90,.45);width:fit-content">
        ${ic('bell',12,2,'var(--ink)')}<span style="font-size:12px;font-weight:500;color:var(--ink2)">Aira will remind you in 10 minutes</span></div>`:''}
      <div class="row" style="gap:5px;margin-top:20px">
        ${[0,1,2,3,4].map(k=>`<span style="flex:1;height:3px;border-radius:99px;background:${k<=i?'var(--ink)':'rgba(16,16,17,.12)'}"></span>`).join('')}</div>
      <div class="row" style="gap:10px;margin-top:16px">
        ${i>0?`<button data-act="gback" style="width:52px;height:52px;border-radius:50%;background:#fff;border:1px solid var(--hair);
          display:flex;align-items:center;justify-content:center;flex:none">${ic('chevron',14,2.2,'var(--ink)','transform:rotate(180deg)')}</button>`:''}
        ${cta(i===4?'Tube done':'Next','data-act="gnext"')}</div></div></div>`;
}

/* -- Report -- */
function shReport(){
  const ch=S.reportChapter;
  let body='';
  if(ch===0){
    body=`<div class="litecard">${sectionLabel('Facts')}
      <div style="font-size:14px;line-height:1.55;margin-top:8px">Five samples on 10/15: 4.20 / 5.53 / 2.33 / 1.69 / 1.29 ng/mL.</div>
      <div class="row" style="gap:6px;margin-top:10px">${['Saliva · Eurofins','Original units: ng/mL'].map(s=>
        `<span style="font-size:10.5px;color:var(--ink2);padding:4px 9px;border-radius:99px;background:#fff">${s}</span>`).join('')}</div></div>
    <div class="fog cool"><div class="bg"></div><div class="pad">
      <div class="cardhead"><div class="ibadge">${ic('breath',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">HPA axis</div><div class="b">Saliva · 10/15 · 5 points</div></div>
        ${chipEl('Slower regulation','warn')}</div>
      <div class="row" style="gap:7px;align-items:baseline;margin-top:12px">
        <span class="num" style="font-size:27px;color:var(--amber)">Tense</span>
        <span style="font-size:12.5px;color:var(--onD2)">Strained</span></div>
      <div style="font-size:12.5px;color:var(--onD2);margin-top:5px">Can't get going in the morning, can't switch off at night</div>
      <div style="margin-top:10px">${hpaDeviation()}</div>
      <div style="font-size:10px;color:var(--onD3);margin-top:4px">— — Dashed = Balanced reference shape</div>
      <div style="display:flex;flex-direction:column;gap:12px;margin-top:12px">
        ${[['var(--sky)',"Can't get going in the morning","The rise that should follow waking didn't happen — your body hasn't entered a ready state, so the first hour or two feels dull.",'CAR 32%','expected >50%','var(--sky)'],
           ['var(--coral)',"Can't switch off all day","The hours that should drop never did — your body stays on alert, so unwinding and falling asleep get harder.",'AUCg 33.3','Balanced 22.0','var(--amber)']]
          .map(r=>`<div class="row" style="gap:10px;align-items:flex-start">
          <span style="width:12px;height:12px;border-radius:4px;background:${r[0]};opacity:.8;flex:none;margin-top:3px"></span>
          <div style="flex:1"><div style="font-size:13.5px;font-weight:600">${r[1]}</div>
            <div style="font-size:11.5px;color:var(--onD2);line-height:1.5;margin-top:3px">${r[2]}</div></div>
          <div style="text-align:right;flex:none"><div class="num" style="font-size:13px;color:${r[5]}">${r[3]}</div>
            <div style="font-size:9.5px;color:var(--onD3)">${r[4]}</div></div></div>`).join('')}</div>
      <div class="hair-d" style="margin:13px 0"></div>
      ${stateStrip(3)}
      <div style="font-size:12.5px;font-weight:600;margin-top:13px">Strained = can't start when you should, can't stop when you should.</div>
      <div style="font-size:12px;color:var(--onD2);margin-top:2px">Matches what you said about waking tired and falling asleep later.</div>
      <div class="row" style="gap:7px;margin-top:12px">${chipEl('DHEA 2.1 low','warn')}${chipEl('Testosterone/cortisol 0.38','off')}</div>
      ${qualifier('Only one day','Only one day sampled. Add the +30 min and before-bed points to confirm this is a stable state, not a one-day swing.','Schedule a re-test','data-act="retest"')}
      <div style="display:flex;gap:7px;flex-wrap:wrap;margin-top:14px">
        ${[['What does Strained mean?',"Can't start when you should, can't stop when you should. The morning rise never happened (CAR 32%, expected >50%) and the afternoon and evening never came down (AUCg 33.3 vs 22.0 for Balanced)."],
           ['Is it related to my sleep?','Directionally yes: not switching off at night makes falling asleep harder, and your onset is 50 min later than usual. But with one day sampled I can\'t tell cause from coincidence.'],
           ['How do we find out?','Collect 2 more days at the same time points (+30 min after waking and before bed), and log whether there was night caregiving. A shape that repeats across both days counts as a stable state.']]
          .map((q,i)=>`<button class="evchip" data-qa="${i}" style="font-size:11px">${ic('ask',11,2,'var(--lime)')} ${q[0]}</button>
            <div id="qa-${i}" style="display:none;width:100%;font-size:12px;color:var(--onD2);line-height:1.55;
              padding:10px 12px;border-radius:11px;background:rgba(255,255,255,.06)">${q[1]}</div>`).join('')}</div>
    </div></div>`;
  } else if(ch===1){
    body=`<div class="litecard">${sectionLabel('Facts')}
      <div style="font-size:14px;line-height:1.6;margin-top:8px">Device: cortisol is lowest 14:00–16:00.<br>Self-report: 4 of 5 days rated 1–2 at 14:00.</div></div>
    <div class="fog cool"><div class="bg"></div><div class="pad">
      <div class="cardhead"><div class="ibadge">${ic('pulse',16,1.7,'#fff')}</div>
        <div class="tt"><div class="a">Felt vs. measured</div><div class="b">Device × self-report</div></div>
        ${chipEl('4 of 5 days match','sky')}</div>
      <div style="margin-top:12px">${dualTrack()}</div>
      <div style="font-size:13.5px;line-height:1.55;margin-top:8px">You run low in the afternoon and evening — exactly when you said you feel the slump.</div>
      ${qualifier("Day 5 didn't match","That day was rated 3 at 14:00. One day of saliva still can't confirm the cause.")}</div></div>
    <div class="fog flat"><div class="bg"></div><div class="pad">
      <div class="cardhead"><div class="ibadge" style="background:rgba(220,245,90,.2)"><span style="color:var(--lime);font-weight:700;font-size:13px">?</span></div>
        <div class="tt"><div class="a">A hypothesis from Aira</div></div>${chipEl('Unconfirmed','off')}</div>
      <div style="font-size:17px;font-weight:600;letter-spacing:-.4px;margin-top:12px">Is the short sleep related to cortisol?</div>
      ${evid('Supports','var(--lime)',['64 min less sleep per night over 7 days','Cortisol 1.69 at 16:00 — below the usual range','Self-reported afternoon slump on 4 of 5 days'])}
      ${evid('Against / unknown','var(--coral)',['Saliva sampled on only 1 day','Night caregiving and a work crunch overlap — inseparable','Biotin use before testing was never verified'])}
      ${qualifier('How to verify','Collect 2 more days at the same time points and log whether there was night caregiving. Only a repeated shape counts as stable.')}</div></div>`;
  } else {
    body=`<div class="litecard">${sectionLabel('Why this chapter exists')}
      <div style="font-size:17px;font-weight:600;letter-spacing:-.4px;margin-top:8px">Because "not yet known" matters as much as the conclusion.</div>
      <div style="font-size:13px;color:var(--ink2);line-height:1.55;margin-top:6px">If Aira buried caveats in grey fine print you'd skip them — and we'd be pretending to know everything.</div></div>
    <div class="fog alert"><div class="bg"></div><div class="pad">
      ${cardHead('info','Time points and sample size','Affects the state call','1 day','warn')}
      <div class="row" style="gap:5px;margin-top:14px">${['C1','C2','C3','C4','C5'].map(s=>`<div style="flex:1;text-align:center">
        <div style="height:22px;border-radius:6px;background:var(--lime)"></div>
        <div style="font-size:8.5px;color:var(--onD3);margin-top:5px">${s}</div></div>`).join('')}</div>
      <div style="font-size:12.5px;color:var(--onD2);line-height:1.55;margin-top:12px">All five points were collected, so a state can be computed. But it's one day — and Balanced and Strained overlap on single-day data.</div></div></div>
    <div class="fog flat"><div class="bg"></div><div class="pad">
      <div style="font-size:10px;font-weight:600;letter-spacing:1.6px;text-transform:uppercase;color:var(--onD3)">Three things we're not concluding</div>
      <div style="display:flex;flex-direction:column;gap:0;margin-top:13px">
      ${[['Night caregiving vs. work stress — which dominates','They overlap; separating them needs a window with only one present'],
         ['Whether biotin affected this assay','Not verified before collection. Immunoassays are biotin-sensitive'],
         ['Whether low DHEA is chronic or recent','One measurement, no baseline to compare']].map((p,i)=>`
        ${i?'<div class="hair-d" style="margin:11px 0 9px"></div>':''}
        <div><div style="font-size:13.5px;font-weight:600">${p[0]}</div>
          <div style="font-size:12px;color:var(--onD2);line-height:1.5;margin-top:3px">${p[1]}</div></div>`).join('')}</div></div></div>
    <div class="row" style="gap:8px;align-items:flex-start;padding:9px 12px;border-radius:11px;background:rgba(16,16,17,.04);
         border:1px dashed rgba(255,184,92,.9)">
      <span style="color:var(--amber);font-weight:700;font-size:12px">!</span>
      <div><div style="font-size:11.5px;font-weight:500">Apple Health · Mock data</div>
        <div style="font-size:10px;color:var(--ink3)">This demo uses mock data, not real results</div></div></div>`;
  }
  return `<div class="grab"></div>
    <div class="row" style="padding:16px 20px 0">
      <div style="flex:1">${sectionLabel('Saliva report · collected 10/15')}
        <div style="font-size:20px;font-weight:600;letter-spacing:-.5px;margin-top:2px">Your state: Strained</div></div>
      <button data-act="closesheet" style="width:32px;height:32px;border-radius:50%;background:var(--hair2);
        display:flex;align-items:center;justify-content:center">${ic('close',12,2.3,'var(--ink2)')}</button></div>
    <div class="chtabs">${['01 HPA axis','02 vs. how you felt','03 Still uncertain'].map((c,i)=>
      `<button class="${ch===i?'on':''}" data-act="chapter" data-v="${i}">${c}</button>`).join('')}</div>
    <div class="scroll" style="padding:16px 20px 40px;display:flex;flex-direction:column;gap:16px">
      ${body}
      ${cta('Build the plan','data-act="buildplan"')}
    </div>`;
}
function evid(title,c,items){
  return `<div style="margin-top:13px"><div style="font-size:9px;font-weight:700;letter-spacing:1.3px;text-transform:uppercase;color:${c}">${title}</div>
    <div style="display:flex;flex-direction:column;gap:5px;margin-top:5px">${items.map(s=>
      `<div class="row" style="gap:7px;align-items:flex-start"><span style="color:var(--onD3)">·</span>
       <span style="font-size:12px;color:var(--onD2);line-height:1.5">${s}</span></div>`).join('')}</div></div>`;
}
function dualTrack(w=312,h=110){
  // measured cortisol (lime) vs self-reported energy (white dashed) across the day
  const cort=[[7,.55],[9,.75],[11,.45],[13,.3],[15,.2],[17,.22],[19,.2],[21,.17]];
  const felt=[[8,.65],[10,.55],[12,.5],[14,.15],[16,.18],[18,.32],[20,.3]];
  const pl=8,pr=8,pt=12,pb=26;
  const X=hr=>pl+(w-pl-pr)*(hr-7)/14, Y=v=>pt+(h-pt-pb)*(1-v);
  let s=`<svg width="100%" viewBox="0 0 ${w} ${h}" style="display:block">`;
  s+=`<rect x="${X(14)}" y="${pt}" width="${X(16)-X(14)}" height="${h-pt-pb}" rx="6" fill="rgba(255,138,91,.12)"/>`;
  s+=`<path d="${smoothPath(cort.map(([hr,v])=>[X(hr),Y(v)]))}" stroke="var(--lime)" stroke-width="2" fill="none"/>`;
  s+=`<path d="${smoothPath(felt.map(([hr,v])=>[X(hr),Y(v)]))}" stroke="rgba(255,255,255,.75)" stroke-width="1.6" stroke-dasharray="4 3" fill="none"/>`;
  s+=`<text x="${X(15)}" y="${h-12}" fill="var(--coral)" font-size="9" text-anchor="middle">the slump</text>`;
  [8,12,16,20].forEach(hr=>s+=`<text x="${X(hr)}" y="${h-2}" fill="rgba(255,255,255,.35)" font-size="8.6" text-anchor="middle">${hr}:00</text>`);
  s+=`<text x="${pl}" y="10" fill="var(--lime)" font-size="8.6">— cortisol</text>
      <text x="${pl+64}" y="10" fill="rgba(255,255,255,.6)" font-size="8.6">- - how you felt</text>`;
  return s+'</svg>';
}

/* -- Check-in -- */
function shCheckin(){
  return sheetHead('Check in')+`
    <div class="scroll" style="padding:14px 22px 40px">
      <div style="font-size:13.5px;color:var(--ink2);line-height:1.5">A watch measures heart rate. It can't measure how you feel. One question, once a day.</div>
      <div style="text-align:center;margin-top:28px">${face(S.feel,96,'#3c3c40',2.2)}
        <div style="font-size:19px;font-weight:600;letter-spacing:-.4px;margin-top:10px">${faceNames[S.feel]}</div>
        <div style="font-size:12px;color:var(--ink3);margin-top:2px">${(S.feel+1).toFixed(1)} / 5</div></div>
      <div class="row" style="gap:8px;margin-top:26px">
        ${faceNames.map((n,i)=>`<button data-act="feel" data-v="${i}" style="flex:1;padding:12px 2px;border-radius:16px;
          background:${S.feel===i?'var(--lime)':'#fff'};border:1px solid ${S.feel===i?'var(--lime)':'var(--hair)'};
          display:flex;flex-direction:column;align-items:center;gap:6px">
          ${face(i,26,'#3c3c40',1.6)}<span style="font-size:8.5px;color:var(--ink2)">${n}</span></button>`).join('')}</div>
      <div style="margin-top:28px">${cta('Log it','data-act="logfeel"')}</div>
      <div style="text-align:center;font-size:11px;color:var(--ink3);margin-top:12px">About 20 seconds. Aira only asks once a day.</div>
    </div>`;
}

/* -- Ask about plan -- */
function shAsk(){
  const qa=[['Why is wake time first?','Highest weight (9.1), and the only intervention acting on both ends — fix the wake time and sleep onset drifts earlier on its own.'],
    ['Do I need supplements?','No. No supplement advice this round — your data can\'t support that call yet, and behavioural interventions have stronger evidence.'],
    ["What if I can't do it daily?","Weekdays only is fine. Just don't break for 3 days in a row — that re-drifts a rhythm you just steadied."]];
  return sheetHead('Ask about this plan')+`
    <div class="scroll" style="padding:10px 20px 40px;display:flex;flex-direction:column;gap:10px">
      ${qa.map((q,i)=>`<button data-qa="${i}" class="wcard" style="padding:15px 16px;text-align:left;width:100%">
        <span class="row" style="gap:9px">${ic('ask',15,2,'var(--ink)')}<span style="flex:1;font-size:14px;font-weight:500">${q[0]}</span>
          ${ic('chevron',11,2.2,'var(--ink3)','transform:rotate(90deg)')}</span></button>
        <div id="qa-${i}" style="display:none;font-size:13px;color:var(--ink2);line-height:1.6;padding:2px 16px 8px">${q[1]}</div>`).join('')}</div>`;
}

/* -- Arrange -- */
function shArrange(){
  const a=S.sheetArg;
  const slots=['Morning · 07:00','Afternoon · 13:30','Evening · 18:00','Before bed · 22:00'];
  const rec=(a.icon==='meditate'||a.icon==='read')?3:(a.icon==='coffee'?1:2);
  if(S._arrMin==null){ S._arrMin=a.defaultMin||20; S._arrSlot=rec; }
  const reason=[,'Afternoon — your 13:10–15:50 sitting block sits right on the energy trough.',
    'Evening — at least 3 h before bed, so onset doesn\'t slide later.',
    'Before bed — your problem is not switching off at night, so this slot pays the most.'][S._arrSlot]||'Evening — at least 3 h before bed.';
  return sheetHead('Arrange')+`
    <div class="scroll" style="padding:10px 20px 40px">
      <div class="row" style="gap:14px;margin-top:8px">
        <span style="width:92px;height:92px;border-radius:20px;background:${a.tint};display:flex;align-items:center;justify-content:center">${ic(a.icon,40,1.6,'rgba(16,16,17,.8)')}</span>
        <div><div style="font-size:22px;font-weight:600;letter-spacing:-.6px">${a.name}</div>
          <div style="font-size:12.5px;color:var(--ink3);margin-top:3px">${a.sub}</div></div></div>
      <div style="margin-top:24px">${sectionLabel('Duration')}</div>
      <div class="row" style="gap:8px;margin-top:10px">${[10,15,20,30,45].map(m=>`<button data-act="arrmin" data-v="${m}"
        style="flex:1;padding:13px 2px;border-radius:14px;font-size:14px;${S._arrMin===m?'background:var(--ink);color:#fff;font-weight:600':'background:#fff;border:1px solid var(--hair);color:var(--ink2)'}">${m}</button>`).join('')}</div>
      <div style="margin-top:20px">${sectionLabel('Time of day')}</div>
      <div style="display:flex;flex-direction:column;gap:8px;margin-top:10px">
        ${slots.map((s,i)=>`<button data-act="arrslot" data-v="${i}" class="row" style="gap:8px;padding:14px 16px;border-radius:15px;text-align:left;
          background:${S._arrSlot===i?'rgba(220,245,90,.4)':'#fff'};border:1px solid ${S._arrSlot===i?'rgba(16,16,17,.85)':'var(--hair)'}">
          <span style="font-size:14.5px;${S._arrSlot===i?'font-weight:600':''}">${s}</span>
          ${i===rec?'<span style="font-size:10px;font-weight:600;padding:3px 7px;border-radius:99px;background:var(--lime)">Aira suggests</span>':''}
          <span style="margin-left:auto">${S._arrSlot===i?ic('check',15,2.2,'var(--ink)'):''}</span></button>`).join('')}</div>
      <div class="row" style="gap:9px;align-items:flex-start;margin-top:16px;padding:13px;border-radius:15px;background:rgba(220,245,90,.4)">
        ${ic('spark',13,2,'var(--ink)','margin-top:1px')}<span style="font-size:12.5px;color:var(--ink2);line-height:1.5">${reason}</span></div>
      <div style="margin-top:22px">${cta('Add to plan','data-act="arradd"')}</div></div>`;
}

/* ================= Analyzing overlay ================= */
const $anal=document.getElementById('analyzing');
function deliverReport(){
  S.points.forEach(p=>p.done=true);
  closeSheet();
  const lines=['Reading 5 saliva time points','Aligning them with 30 days of sleep',
    'Comparing against your own baseline',"Separating what's known from what isn't"];
  $anal.className='open';
  $anal.innerHTML=`<div class="fogscreen"></div>
    <div style="position:relative;height:100%;display:flex;flex-direction:column;justify-content:center;color:#fff;text-align:center;padding:0 40px">
      ${textSphere(250,80)}
      <div style="font-size:22px;font-weight:600;letter-spacing:-.5px;margin-top:26px">Joint analysis</div>
      <div id="an-line" style="font-size:13.5px;color:rgba(255,255,255,.62);margin-top:10px;height:20px">${lines[0]}</div>
      <div id="an-bar" style="margin:30px 46px 0">${neonBar(0)}</div>
      <div id="an-pct" class="num" style="font-size:11px;color:rgba(255,255,255,.4);margin-top:12px">0%</div>
      <div style="position:absolute;bottom:34px;left:0;right:0;font-size:11px;color:rgba(255,255,255,.34);line-height:1.5">
        This takes a moment — it's reading both sides against each other,<br>not scoring them separately.</div></div>`;
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
  ['Welcome',3.0,()=>{reset();}],
  ['Connect data',2.4,()=>{S.phase='connect';S.healthGranted=true;}],
  ['Importing 30 days',4.0,()=>{beginSync();}],
  ['First read',4.2,()=>{S.phase='recap';}],
  ['About you',2.6,()=>{S.phase='profile';S.profStep=0;S.nickname='Chloe';}],
  ['Do you train?',2.4,()=>{S.phase='profile';S.profStep=1;}],
  ['Health background',2.6,()=>{S.phase='medical';S.meds.add('Biotin (vitamin B7)');}],
  ['Home · daily loop',3.6,()=>{S.phase='main';S.tab=0;closeSheetNow();}],
  ['Aira opens the thread',3.6,()=>{S.phase='main';S.tab=1;}],
  ['Why saliva?',3.2,()=>{S.phase='main';S.tab=1;if(!S.sent.includes('Why saliva?'))S.sent.push('Why saliva?');}],
  ['Schedule collection',2.6,()=>{S.phase='main';S.tab=1;if(!S.sent.includes('Schedule for tomorrow'))S.sent.push('Schedule for tomorrow');if(S.saliva<1)S.saliva=1;}],
  ['Collection steps',3.4,()=>{S.phase='main';S.tab=0;S.activePoint=0;S.stepIndex=1;render();openSheet('guidance');}],
  ['Samples done',2.2,()=>{closeSheetNow();S.points.forEach(p=>p.done=true);S.saliva=3;}],
  ['Joint analysis',6.4,()=>{deliverReport();}],
  ['Report',4.4,()=>{S.saliva=4;S.tab=1;render();openSheet('report');}],
  ['Plan',4.0,()=>{closeSheetNow();S.tab=2;}],
  ['Accept top action',3.0,()=>{const d=deck();if(d.length)d[0].state=1;}],
];
const Demo={playing:false,index:0,expanded:false,timer:null};
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
        <span>${Demo.playing?DEMO_STEPS[Math.min(Demo.index,16)][0]:'Play the whole flow'}</span></div>
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
        defaultMin:{'Brisk walk':20,'Running':30,'Cycling':40,'Strength':45,'Swimming':30,'Jump rope':10,
          'Breathwork':10,'Stretching':8,'Walk':15,'Coffee':15,'Dancing':15,'Reading':20}[v]||20}); break;
    case 'arrmin': S._arrMin=+v; refreshSheet(); break;
    case 'arrslot': S._arrSlot=+v; refreshSheet(); break;
    case 'arradd': {
      const a=S.sheetArg, slots=['Morning · 07:00','Afternoon · 13:30','Evening · 18:00','Before bed · 22:00'];
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
    val.innerHTML=`${S[k]}<span>${k==='age'?'years old':'years training'}</span>`;
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
  // deck swipe
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
function wireSheet(){ /* delegated clicks cover sheet; nothing extra */ }

/* boot */
render();

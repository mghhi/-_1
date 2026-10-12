from pathlib import Path
import zipfile, os, textwrap
root=Path("/mnt/data/SalatiWeb")
root.mkdir(exist_ok=True)
html=r'''<!doctype html>
<html lang="ar" dir="rtl">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#174c3c">
<title>صلاتي — متابعة يومية</title>
<style>
:root{--forest:#174c3c;--green:#2f765c;--cream:#f6f3e9;--gold:#d5b56d;--ink:#20332b;--muted:#65756c;--line:#e5e8e0;--white:#fff}
*{box-sizing:border-box} body{margin:0;background:var(--cream);color:var(--ink);font-family:system-ui,-apple-system,"Segoe UI",Tahoma,Arial,sans-serif}
header{background:linear-gradient(135deg,#174c3c,#23644d);color:white;padding:20px 18px 18px;border-radius:0 0 24px 24px}
.top{display:flex;align-items:center;justify-content:space-between;gap:12px}.brand{font-size:28px;font-weight:850;letter-spacing:.2px}.sub{color:#dce9df;font-size:13px;margin-top:2px}.date-nav{display:flex;align-items:center;gap:9px;margin-top:18px}.date-nav button{border:1px solid #ffffff50;background:#ffffff12;color:white;border-radius:10px;padding:8px 12px;font-size:15px}.date-label{flex:1;text-align:center;font-size:13px}
nav{display:flex;gap:7px;padding:12px 12px 2px;position:sticky;top:0;background:var(--cream);z-index:5}
nav button{flex:1;border:0;background:white;color:var(--forest);padding:12px 4px;border-radius:13px;font-weight:700;font-size:14px}nav button.active{background:var(--forest);color:white}
main{padding:12px;max-width:720px;margin:auto}.card{background:white;border-radius:18px;padding:16px;margin-bottom:12px;box-shadow:0 2px 8px #183b2910}.score{background:var(--forest);color:white;display:flex;align-items:center;gap:12px;justify-content:space-between}.score .big{font-size:31px;font-weight:850}.score small{color:#dce9df}.score .ring{border:3px solid var(--gold);border-radius:50%;width:76px;height:76px;display:grid;place-items:center;font-size:20px;font-weight:800;flex-shrink:0}.section-title{font-size:19px;font-weight:850;margin:18px 2px 10px}.prayer-head{display:flex;justify-content:space-between;align-items:center;gap:8px}.prayer-name{font-size:18px;font-weight:800}.points{color:var(--green);font-weight:750;font-size:13px}.options{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:7px;margin-top:12px}.option{display:flex;align-items:center;gap:7px;border:1px solid var(--line);border-radius:11px;padding:10px 8px;font-size:13px;cursor:pointer}.option input{accent-color:var(--green);width:17px;height:17px;margin:0}.option.selected{background:#eaf3ed;border-color:#6da287}.hint{color:var(--muted);font-size:12px;line-height:1.7;margin:10px 3px}.hidden{display:none!important}.pillrow{display:flex;gap:7px}.pillrow button{flex:1;background:white;border:1px solid var(--line);border-radius:12px;padding:10px 5px;color:var(--forest);font-weight:700}.pillrow button.active{background:var(--forest);color:white}.statgrid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:9px}.stat{background:#f7f8f4;border-radius:13px;padding:12px}.stat strong{display:block;font-size:23px;color:var(--forest)}.stat span{font-size:12px;color:var(--muted)}.progress{height:9px;border-radius:99px;background:#e6eae3;overflow:hidden;margin:10px 0}.progress div{height:100%;background:var(--green);border-radius:99px}.dayrow{display:flex;justify-content:space-between;align-items:center;padding:11px 0;border-bottom:1px solid var(--line);gap:8px}.dayrow:last-child{border:0}.dayrow .date{font-weight:700}.dayrow small{display:block;color:var(--muted);font-size:12px;margin-top:3px}.badge{background:#eaf3ed;color:var(--forest);padding:6px 9px;border-radius:9px;font-weight:800;font-size:13px;white-space:nowrap}.habit{display:flex;align-items:center;gap:10px;padding:13px 2px;border-bottom:1px solid var(--line)}.habit:last-child{border:0}.habit input{width:21px;height:21px;accent-color:var(--green)}.habit label{flex:1;font-weight:650}.button{background:var(--forest);color:white;border:0;border-radius:12px;padding:12px 15px;font-weight:750}.button.secondary{background:white;color:var(--forest);border:1px solid var(--line)}.actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:12px}.empty{padding:20px;text-align:center;color:var(--muted)}footer{text-align:center;padding:18px;color:var(--muted);font-size:11px}
@media(min-width:600px){main{padding:18px}.options{grid-template-columns:repeat(4,minmax(0,1fr))}}
</style>
</head>
<body>
<header>
 <div class="top"><div><div class="brand">صَلَاتي</div><div class="sub">خطوة ثابتة كل يوم</div></div><div style="font-size:30px" aria-hidden="true">☾</div></div>
 <div class="date-nav"><button id="prev" aria-label="اليوم السابق">›</button><div id="dateLabel" class="date-label"></div><button id="today">اليوم</button><button id="next" aria-label="اليوم التالي">‹</button></div>
</header>
<nav>
 <button class="active" data-tab="today">اليوم</button><button data-tab="reports">التقارير</button><button data-tab="habits">العادات</button><button data-tab="backup">بياناتي</button>
</nav>
<main>
<section id="today">
 <div class="card score"><div><small>تقييم الفرائض</small><div class="big"><span id="score">0</span> <span style="font-size:15px;font-weight:600">/ 100</span></div><small id="recorded">0 من 5 صلوات مسجلة</small></div><div class="ring"><span id="percent">0%</span></div></div>
 <div class="section-title">الصلوات الخمس</div><div id="prayers"></div>
 <p class="hint">النقاط المقترحة: الصلاة في وقتها 20 نقطة، الصلاة بعد خروج الوقت 5 نقاط، ولم تُصلَّ 0. «لم أسجل» حالة غير محسومة ولا تُحسب كأنها صلاة فائتة. التقييم أداة شخصية لمتابعة الانتظام، وليس حكمًا على قبول العبادة.</p>
</section>
<section id="reports" class="hidden">
 <div class="section-title" style="margin-top:5px">تقرير الأداء</div>
 <div class="pillrow"><button class="active" data-period="week">الأسبوع</button><button data-period="month">الشهر</button><button data-period="year">السنة</button></div>
 <div class="card" style="margin-top:12px"><div class="statgrid"><div class="stat"><span>متوسط النقاط</span><strong id="avg">0%</strong></div><div class="stat"><span>صلوات في وقتها</span><strong id="ontime">0</strong></div><div class="stat"><span>صلوات متأخرة</span><strong id="late">0</strong></div><div class="stat"><span>لم تُصلَّ</span><strong id="missed">0</strong></div></div><div class="progress"><div id="bar" style="width:0%"></div></div><small id="periodCaption" class="hint"></small></div>
 <div class="section-title">السجل اليومي</div><div class="card" id="dayList"></div>
</section>
<section id="habits" class="hidden">
 <div class="section-title" style="margin-top:5px">السنن والقرآن والأذكار</div><div class="card"><p class="hint" style="margin-top:0">متابعة منفصلة عن نقاط الفرائض حتى تقدر تقيس كل جانب لوحده.</p><div id="habitList"></div></div>
 <div class="card"><div class="prayer-head"><strong>إنجاز العادات اليوم</strong><strong class="points" id="habitCount">0 / 7</strong></div><div class="progress"><div id="habitBar" style="width:0%"></div></div></div>
</section>
<section id="backup" class="hidden">
 <div class="section-title" style="margin-top:5px">بياناتك محفوظة على جهازك</div><div class="card"><p>التطبيق يحفظ سجل الصلوات والعادات في متصفح هذا الجهاز. امسح بيانات المتصفح بحذر حتى لا تفقد السجل.</p><div class="actions"><button class="button" id="export">تصدير نسخة احتياطية</button><button class="button secondary" id="importBtn">استعادة نسخة</button><input id="importFile" type="file" accept="application/json" class="hidden"></div><p class="hint">صدّر نسخة احتياطية من وقت لآخر. لا توجد مزامنة سحابية في هذه النسخة.</p></div>
 <div class="card"><strong>طريقة إضافته لشاشة الموبايل</strong><p class="hint">بعد نشر الصفحة على رابط آمن، افتح الرابط في Chrome ثم القائمة ⋮ ثم «إضافة إلى الشاشة الرئيسية». الملف المحلي وحده لا ينشئ رابطًا عامًا.</p></div>
</section>
</main>
<footer>صلاتي — متابعة شخصية برفق واستمرار</footer>
<script>
const prayerNames=["الفجر","الظهر","العصر","المغرب","العشاء"];
const statuses=[["unrecorded","لم أسجل"],["ontime","في الوقت"],["late","متأخرة"],["missed","لم أُصلِّ"]];
const habits=["سنة الفجر","السنن الرواتب","صلاة الوتر","ورد القرآن","أذكار الصباح","أذكار المساء","أذكار بعد الصلاة"];
let selectedDate=new Date(); selectedDate.setHours(12,0,0,0);
let period="week";
const pad=n=>String(n).padStart(2,"0");
const keyDate=d=>`${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
const arDate=d=>new Intl.DateTimeFormat("ar-EG",{weekday:"long",day:"numeric",month:"long",year:"numeric"}).format(d);
const load=d=>{try{return JSON.parse(localStorage.getItem("salati:"+keyDate(d))||"{}")}catch(e){return {}}};
const save=(d,obj)=>localStorage.setItem("salati:"+keyDate(d),JSON.stringify(obj));
const points=s=>s==="ontime"?20:s==="late"?5:0;
function updateDate(){document.getElementById("dateLabel").textContent=arDate(selectedDate);renderAll()}
function setStatus(name,value){let r=load(selectedDate);r.prayers=r.prayers||{};r.prayers[name]=value;save(selectedDate,r);renderAll()}
function setHabit(name,value){let r=load(selectedDate);r.habits=r.habits||{};r.habits[name]=value;save(selectedDate,r);renderAll()}
function renderPrayers(){
 const r=load(selectedDate), ps=r.prayers||{};let total=0,recorded=0;
 document.getElementById("prayers").innerHTML=prayerNames.map(name=>{
 const st=ps[name]||"unrecorded";total+=points(st);if(st!=="unrecorded")recorded++;
 return `<div class="card"><div class="prayer-head"><div class="prayer-name">${name}</div><div class="points">${points(st)} نقطة</div></div><div class="options">${statuses.map(([v,label])=>`<label class="option ${st===v?"selected":""}"><input type="radio" name="p-${name}" value="${v}" ${st===v?"checked":""}><span>${label}</span></label>`).join("")}</div></div>`
 }).join("");
 document.getElementById("prayers").querySelectorAll("input").forEach(input=>input.addEventListener("change",e=>setStatus(e.target.name.slice(2),e.target.value)));
 document.getElementById("score").textContent=total;document.getElementById("percent").textContent=total+"%";document.getElementById("recorded").textContent=`${recorded} من 5 صلوات مسجلة`;
}
function renderHabits(){const r=load(selectedDate),hs=r.habits||{};const count=habits.filter(h=>hs[h]).length;
 document.getElementById("habitList").innerHTML=habits.map(h=>`<div class="habit"><input type="checkbox" id="h-${habits.indexOf(h)}" ${hs[h]?"checked":""}><label for="h-${habits.indexOf(h)}">${h}</label><span class="points">${hs[h]?"تم ✓":""}</span></div>`).join("");
 habits.forEach((h,i)=>document.getElementById("h-"+i).addEventListener("change",e=>setHabit(h,e.target.checked)));
 document.getElementById("habitCount").textContent=`${count} / ${habits.length}`;document.getElementById("habitBar").style.width=(count/habits.length*100)+"%";
}
function dateRange(){const end=new Date();end.setHours(12,0,0,0);let start=new Date(end);
 if(period==="week")start.setDate(end.getDate()-6);
 else if(period==="month")start=new Date(end.getFullYear(),end.getMonth(),1,12);
 else start=new Date(end.getFullYear(),0,1,12);
 const arr=[];for(let d=new Date(start);d<=end;d.setDate(d.getDate()+1))arr.push(new Date(d));return arr.reverse()}
function renderReports(){const dates=dateRange();let sum=0,on=0,late=0,miss=0;const data=dates.map(d=>{const r=load(d),ps=r.prayers||{};let p=0,rec=0;prayerNames.forEach(n=>{const s=ps[n]||"unrecorded";p+=points(s);if(s!=="unrecorded")rec++;if(s==="ontime")on++;if(s==="late")late++;if(s==="missed")miss++});sum+=p;return {d,p,rec}});
 const max=dates.length*100,avg=max?Math.round(sum/max*100):0;document.getElementById("avg").textContent=avg+"%";document.getElementById("ontime").textContent=on;document.getElementById("late").textContent=late;document.getElementById("missed").textContent=miss;document.getElementById("bar").style.width=avg+"%";
 document.getElementById("periodCaption").textContent=`${dates.length} يومًا · ${sum} نقطة من ${max} نقطة ممكنة`;
 document.getElementById("dayList").innerHTML=data.map(({d,p,rec})=>`<div class="dayrow"><div class="date">${new Intl.DateTimeFormat("ar-EG",{weekday:"short",day:"numeric",month:"short"}).format(d)}<small>تم تسجيل ${rec} من 5 صلوات</small></div><span class="badge">${p}/100</span></div>`).join("")||'<div class="empty">لا توجد بيانات حتى الآن</div>';
}
function renderAll(){renderPrayers();renderHabits();renderReports()}
document.querySelectorAll("nav button").forEach(b=>b.addEventListener("click",()=>{document.querySelectorAll("nav button").forEach(x=>x.classList.toggle("active",x===b));["today","reports","habits","backup"].forEach(id=>document.getElementById(id).classList.toggle("hidden",id!==b.dataset.tab));renderAll()}));
document.getElementById("prev").onclick=()=>{selectedDate.setDate(selectedDate.getDate()-1);updateDate()};
document.getElementById("next").onclick=()=>{selectedDate.setDate(selectedDate.getDate()+1);updateDate()};
document.getElementById("today").onclick=()=>{selectedDate=new Date();selectedDate.setHours(12,0,0,0);updateDate()};
document.querySelectorAll("[data-period]").forEach(b=>b.onclick=()=>{period=b.dataset.period;document.querySelectorAll("[data-period]").forEach(x=>x.classList.toggle("active",x===b));renderReports()});
document.getElementById("export").onclick=()=>{const data={app:"Salati",version:1,records:{}};Object.keys(localStorage).filter(k=>k.startsWith("salati:")).forEach(k=>data.records[k]=JSON.parse(localStorage.getItem(k)));const blob=new Blob([JSON.stringify(data,null,2)],{type:"application/json"});const a=document.createElement("a");a.href=URL.createObjectURL(blob);a.download="salati-backup.json";a.click();URL.revokeObjectURL(a.href)};
document.getElementById("importBtn").onclick=()=>document.getElementById("importFile").click();
document.getElementById("importFile").onchange=async e=>{const f=e.target.files[0];if(!f)return;try{const data=JSON.parse(await f.text());if(!data.records)throw Error();Object.entries(data.records).forEach(([k,v])=>{if(k.startsWith("salati:"))localStorage.setItem(k,JSON.stringify(v))});alert("تمت استعادة النسخة الاحتياطية");renderAll()}catch(err){alert("الملف غير صالح أو ليس نسخة من صلاتي")}e.target.value=""};
updateDate();
</script>
</body></html>'''
(root/"index.html").write_text(html,encoding="utf-8")
readme="""صلاتي — نسخة ويب تعمل على الموبايل

- افتح index.html في متصفح حديث لتجربة الواجهة. بعض المتصفحات قد تمنع وظائف التخزين عند فتح ملف محلي؛ الأفضل استضافة الصفحة على رابط HTTPS.
- بعد نشرها على HTTPS، افتح الرابط في Chrome على أندرويد > القائمة ⋮ > إضافة إلى الشاشة الرئيسية.
- يحفظ السجل محليًا داخل المتصفح. استخدم «بياناتي» لتصدير نسخة احتياطية واستعادتها.
- لا توجد تنبيهات أو مزامنة سحابية في هذه النسخة.
"""
(root/"README.txt").write_text(readme,encoding="utf-8")
zipfile_path="/mnt/data/Salati_Mobile_Web.zip"
with zipfile.ZipFile(zipfile_path,"w",zipfile.ZIP_DEFLATED) as z:
    z.write(root/"index.html","index.html")
    z.write(root/"README.txt","README.txt")
print("Created",zipfile_path, "HTML bytes",len(html))
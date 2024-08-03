var list_news = [
   {date: "01.01.2000", name:"Сильно Очень Длинное Название вкладки"},
   {date: "22.01.2005", name:"Очень Длинное Название вкладки"},
   {date: "01.01.2023", name:"Длинное Название вкладки"},
   {date: "01.01.2024", name:"Название вкладки"},
   {date: "01.01.2024", name:"Название вкладки"},
   {date: "01.01.2024", name:"Название вкладки"},
   {date: "01.01.2024", name:"Название вкладки"},
   {date: "01.01.2024", name:"Название вкладки"},
   {date: "01.01.2024", name:"Название вкладки"},
 ];

var menu = document.getElementById("menu");

for (let k in list_news) {
   // menu.innerHTML += `<li onclick="openNews(event, 'news-${k}')" class="tablinks"><a href="#">${list_news[k]}  news${k}</a></li>`;
   menu.innerHTML += `<li onclick="openNews(event, 'news-${k}')" class="tablinks"><a href="#news-${k}">${list_news[k].name}</a><span><i class="fa-solid fa-calendar-days"></i> ${list_news[k].date} ID: ${k}</span></li>`;
};

function openNews(evt, newsName) {
   var i, newsContent, tablinks;
   
   newsContent = document.getElementsByClassName("newsContent");
   content = document.getElementsByClassName("content");
   for (i = 0; i < newsContent.length; i++) {
     newsContent[i].style.display = "none";
   }
   
   tablinks = document.getElementsByClassName("tablinks");
   for (i = 0; i < tablinks.length; i++) {
     tablinks[i].className = tablinks[i].className.replace(" active", "");
   }
   document.getElementById(newsName).style.display = "block";
   evt.currentTarget.className += " active";
 };
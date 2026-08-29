const fs = require('fs');

const csv = `accs ,accessibility{key:5*⇧⇠}
acr ,accordingly{key:2*⇧⇠}
actv ,activities{key:2*⇧⇠}
Ang ,Angular
anl ,analysis
apr ,approach
aprt ,appropriate
aprx ,approximate
apt ,apparently{key:2*⇧⇠}
asa ,as soon as
asw ,as well as 
atst ,at the same time
attm,at the moment
aut ,automatically{key:4*⇧⇠}
avi ,availability{key:5*⇧⇠}
bg ,background
bgn ,beginning
bh ,behaviour
bs ,business
bt ,button
cc ,concept
chr ,characteristics{key:6*⇧⇠}
cll ,collection{key:3*⇧⇠}
cm ,comment
cmd ,commands{key:1*⇧⇠}
cmn ,communication{key:3*⇧⇠}
cmp ,components{key:1*⇧⇠}
cmy ,community
cnd ,condition
cnn ,connection
cnt ,contents{key:1*⇧⇠}
cnv ,convenient
cnx ,contextual
cr ,current
crc ,correctly{key:2*⇧⇠}
crt ,certainly{key:2*⇧⇠}
cst ,constraints
cy ,certainlyakey
dc ,document
dct ,directly{key:2*⇧⇠}
ddd ,{DD}.{MM}.{YYYY}
dfc ,difficult
dff ,different{key:1*⇧⇠}
dlv ,deliverable
dm ,demonstration{key:3*⇧⇠}
DoD,Definition of Done:
ds ,design
dsc ,description{key:5*⇧⇠}
dsst,design system
dvl ,development{key:4*⇧⇠}
ecn ,economic
elm ,elements{key:1*⇧⇠}
env,environment
ev ,evaluation{key:3*⇧⇠}
exc ,excerpt
exec ,expectation
exm ,examples{key:1*⇧⇠}
exp ,experience
exr ,experiment
fex ,"for example, {key:2*⇧⇠}"
fll ,following{key:3*⇧⇠}
fn ,functionality{key:5*⇧⇠}
frq ,frequently{key:2*⇧⇠}
gdl ,guidelines{key:1*⇧⇠}
hf ,hopefully
ht ,https://
imd ,immediately{key:2*⇧⇠}
imp ,important
impl ,implementation{key:5*⇧⇠}
incl ,including
inf ,information
ino ,in order to
intf ,interface
intr ,interaction
inw ,interview
kb ,keyboard
lng ,languages{key:1*⇧⇠}
ly ,library
mb ,maybe
mlt ,multiple
mm ,members{key:1*⇧⇠}
mng ,management 
mnt ,mentioned 
msg ,message 
mt ,meeting 
mth ,methodology{key:5*⇧⇠}
obj ,object 
obs ,observation 
obv ,obviously{key:2*⇧⇠}
pbb ,{/Choose */probably{key:1*⇧⇠}/maybe/perhaps/possibly/}
plg ,plugins{key:1*⇧⇠}
pls ,please 
pp ,people 
prb ,problem
prc ,principle 
prd ,production{key:3*⇧⇠}
pres ,presentation 
prf ,performance{key:2*⇧⇠}
prj ,projects{key:1*⇧⇠}
prt ,prototype
prtc ,participants{key:1*⇧⇠}
prv ,previous 
psb ,possibility{key:5*⇧⇠}
pwd ,password
qu ,question
res ,researching{key:3*⇧⇠}
rfr ,refactoring{key:3*⇧⇠}
rg ,regarding 
rl ,really
rlb ,reliability{key:5*⇧⇠}
rmm ,remember
rq ,requirements{key:5*⇧⇠}
rs ,results
rso ,resources
rsp ,responsible{key:2*⇧⇠}
sc ,screen 
sco ,scenarios{key:1*⇧⇠}
scr ,screenshot 
sgn ,significant 
sh ,shortcuts{key:1*⇧⇠}
smr ,similar 
smth ,something 
smtm ,sometimes 
sp ,separate 
spc ,{/Choose */specific{key:2*⇧⇠}/particular/}
spr ,spreadsheet 
ss ,systematic{key:4*⇧⇠}
st ,structure
std ,standards{key:1*⇧⇠}
stg ,staging
sw,software 
tch ,tecnnologies{key:3*⇧⇠}
thy ,Thank you{^}!
tmr ,tomorrow
und ,understand
unf ,unfortunately
vr ,various
whth ,"what do you think{^}, "
атт ,атрибут
вар ,вариант
вз ,возможно{key:1*⇧⇠}
вп ,вопрос
втч ,в том числе 
вщ ,вообще
дба ,должна быть 
дбе ,должен быть 
дбо ,должно быть 
дбы ,должны быть 
дв ,довольно
дгв ,договорились{key:3*⇧⇠}
дз ,дизайн
дкм ,документ
дп ,дополнительный{key:2*⇧⇠}
др ,другой{key:2*⇧⇠}
дств ,действительно
едн ,единственный{key:2*⇧⇠}
жл ,желательно
зад ,задание{key:1*⇧⇠}
звт ,завтра
зг ,заголовок{key:2*⇧⇠}
зд ,здесь
здрв ,здравствуйте!
зкр ,закрывается{key:1*⇧⇠}
зн ,значение{key:1*⇧⇠}
имв ,имеется в виду
индв ,индивидуальный{key:2*⇧⇠}
инст ,инструмент
интр ,интерактивный{key:2*⇧⇠}
инф ,информационный{key:5*⇧⇠}
исп ,использовать{key:5*⇧⇠}
итд ,и т.д. 
кк ,картинка{key:1*⇧⇠}
км ,комментарий{key:1*⇧⇠}
кнр ,конкретный{key:2*⇧⇠}
кнт ,контент
колв ,количество{key:1*⇧⇠}
кпр ,"как правило, "
крт ,"кроме того, "
кт ,который{key:2*⇧⇠}
кц ,коммуникация{key:1*⇧⇠}
лч ,лучше
мб ,может быть
мк ,"мне кажется, "
мм ,мультимедиа
нбх ,необходимый{key:2*⇧⇠}
ндм ,на данный момент
нект ,некоторый{key:2*⇧⇠}
необз ,необязательный{key:2*⇧⇠}
нзв ,название
нпв ,направление{key:2*⇧⇠}
нпр ,"например, "
нпср ,непосредственно 
нсд ,на самом деле 
нск ,несколько
обз ,обязательно{key:1*⇧⇠}
обр ,образом
однв ,одновременно
опр ,определенный{key:2*⇧⇠}
осб ,особенный{key:2*⇧⇠}
осн ,основной{key:2*⇧⇠}
отд ,отдельный{key:2*⇧⇠}
отн ,относительный{key:8*⇧⇠}
отс ,отсутствующий{key:5*⇧⇠}
офц ,официальный{key:2*⇧⇠}
оч ,очень
очв ,очевидно{key:1*⇧⇠}
пдх ,подходящий{key:2*⇧⇠}
пжл ,пожалуйста
пзв ,позволяет
плз ,пользователь{key:1*⇧⇠}
ппрб ,попробовать{key:3*⇧⇠}
прб ,проблема
прв ,правильно
прг ,программа{key:1*⇧⇠}
прдс ,представляет собой
прдщ ,предыдущий{key:2*⇧⇠}
прмщ ,преимущество{key:1*⇧⇠}
прпд ,преподаватель{key:1*⇧⇠}
прпщ ,при помощи
прс ,присутствует{key:3*⇧⇠}
пск ,поскольку
псл ,последний{key:2*⇧⇠}
псм ,посмотреть{key:2*⇧⇠}
пум ,по умолчанию
резт ,результат
рзл ,различный{key:1*⇧⇠}
рзрб ,разработанный{key:4*⇧⇠}
рск ,рассказывает{key:2*⇧⇠}
рсм ,рассматривает{key:2*⇧⇠}
сбс ,собственно
сбщ ,сообщение{key:1*⇧⇠}
свв ,свойство{key:1*⇧⇠}
свр ,современный{key:2*⇧⇠}
свс ,совсем
сг ,сегодня
сд ,сделать
сй ,сейчас
слд ,следующий{key:2*⇧⇠}
спс ,спасибо
спц ,специальный{key:2*⇧⇠}
срв ,средство{key:1*⇧⇠}
ссл ,исследование{key:2*⇧⇠}
ств ,соответственно{key:4*⇧⇠}
стд ,стандартный{key:2*⇧⇠}
стз ,с точки зрения
стрн ,странице{key:1*⇧⇠}
стц ,ситуация{key:1*⇧⇠}
сч ,случай{key:1*⇧⇠}
сщ ,существует{key:3*⇧⇠}
тж ,также
тк ,так как
тл ,только
тобр ,"Таким образом, "
фц ,функция{key:1*⇧⇠}
хрш ,хорошо
чтн ,что-нибудь
чщвс ,чаще всего
эл ,элемент
явл ,является{key:4*⇧⇠}`;

const lines = csv.split('\n');

function parseReplacement(val) {
    // Check for DD.MM.YYYY
    if (val === '{DD}.{MM}.{YYYY}') {
        return `function() return os.date("%d.%m.%Y") end`;
    }
    
    // Check for choose
    let chooseMatch = val.match(/\{\/Choose \*\/(.+?)\/\}/);
    if (chooseMatch) {
        let options = chooseMatch[1].split('/');
        let formattedOptions = options.map(opt => {
            return parseSimpleReplacement(opt);
        });
        
        let funcStr = `function()\n        local choices = {\n            ${formattedOptions.join(',\n            ')}\n        }\n        return choices[math.random(#choices)]\n    end`;
        return funcStr;
    }
    
    return parseSimpleReplacement(val);
}

function parseSimpleReplacement(val) {
    // Check for moveLeft
    let moveLeftMatch = val.match(/^(.*?)\{\^\}(.*?)$/);
    if (moveLeftMatch) {
        let text = moveLeftMatch[1] + moveLeftMatch[2];
        let moveLeft = moveLeftMatch[2].length;
        return `{ text = "${text.replace(/"/g, '\\"')}", moveLeft = ${moveLeft} }`;
    }
    
    // Check for selection
    let selMatch = val.match(/^(.*?)\{key:(\d+)\*⇧⇠\}$/);
    if (selMatch) {
        return `{ text = "${selMatch[1].replace(/"/g, '\\"')}", select = ${selMatch[2]} }`;
    }
    
    // Simple string
    return `"${val.replace(/"/g, '\\"')}"`;
}

console.log("return {");
for (let line of lines) {
    if (!line.trim()) continue;
    
    // Parse trigger and replacement using regex to handle quotes in CSV correctly
    let match = line.match(/^([^,]+)\s*,\s*"(.*?)"$/);
    let trigger, replacement;
    
    if (match) {
        trigger = match[1];
        replacement = match[2];
    } else {
        let commaIdx = line.indexOf(',');
        if (commaIdx > -1) {
            trigger = line.substring(0, commaIdx);
            replacement = line.substring(commaIdx + 1);
        }
    }
    
    if (!trigger) continue;
    
    console.log(`    ["${trigger}"] = ${parseReplacement(replacement)},`);
}
console.log("}");

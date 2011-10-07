;;
;; Mills' prime
;;
;; Elliptic Curve Primality Proving (ECPP) is a method based on elliptic curves to prove the primality
;; of a number. ECPP is currently in practice the fastest known algorithm for testing the primality of
;; general numbers, but the worst-case execution time is not known.
;;
;; In 2006 the largest prime that had been proved with ECPP was the 20,562-digit Mills' prime:
;;
;; (((((((((2^3 + 3)^3 + 30)^3 + 6)^3 + 80)^3 + 12)^3 + 450)^3 + 894)^3 + 3636)^3 + 70756)^3 +97220
;;
;; Our interest in this number is in the recursive manner in which the number is defined.
;;
;; To wit, consider the following procedure:
;;
(defn cube [x] (* x x x))

(defn mills-iter [x t]
  (cond (> (count x) 0) (mills-iter (rest x) (+ (cube t) (first x)))
        :else t))

;;
;; With this, we can define Mills' prime as follows:
;;
(defn mills-prime []
  (mills-iter (list 0 2 3 30 6 80 12 450 894 3636 70756 97220) 0))

;; ==> 175049840589391837793576869636630282687487868795376789295253428073334270434688134999125968026139390543910871978662703879908672900309477846234471260898315901137250286746017439819666550755165056255377926149901606226673376448218322416576264035249277817797775477188625305240537051825615164306680529434650063201323757773367501095634741003772015982193942957994762856892219237660046554185127347627921275535592307628777006922225841737012591382270717426709013821581956975461302109821547668641004492525715529985651051202873099657583770300139681409562427708589654872188583135316050795345794942830571060729914470361837808487520271249201057934896013828500896313285032413011454945373064319177214895240329829796606939891154504671948341249800939008520926007021638021667636736687589633620799869670663196369272540567170827674187474402546518019309161787433824678193835615199376083151429503930246001878031277682870834384655126476772667414425283868268414488581619432342754529295366937613262771762988812060263125085422085911596177214980090953568069012159107570122467892313399809144672345862250834636947507426712554564740686324292756616096983941549683435270740164350440872886836649405973564616048744661677604903300650476717750997301870435449015567025808386431174810755702620393344836119118035218811868959624318093407144008348814266122811038798076214315556444990052140952243417821306633709790850391804525870884896124189811228248159483101963106546352318039380729575958104007787788053180456344622317187645016318217113275525759412274882937261895474022721834387552074779125912207373207026036289032476299967096301099201403724847576417277953145785431234102606742230817686670058325674147005874890586051281138000602622765926646783348466122583580360407667566276806351699678747027786015358911728903319854926631282902843163112471935704410339820039661180624441370174622476731339753030786028786642180289192279615854051358689351993821321219681277136760343362401489716865065932904503099831517796493608989352689310998651433210094340137664544292951889286341556164957918065361123980193603471492620279327178328425406948319634785606739771802799334980193207565801671393658315922448009298799796528742429046836328790371184198457074306994434339133128049132380096135898825008905101327930322480999920599139235118198594358083503693536728517304691382538269092489478892219787074840500637262774230420292166387473147035031918223113678220463571268617689505790595980960477761172698433396461679394947676952298714016902371215504231672279214102083853891167744895732638759096404781245921828402357056705532657490928631823655860259191751806821050909334712179349610529904443432958277854739674155764211919089829939820070685462601844980641807955776474213493152845207833745016657651916059728669362263789172251359552838333312314019043263188905833697159825983930396590468742899851818816212776598041824702958435211613170590970882134333605109276044573978157941384678422414643251059397675971724902059952789221803758484242377141829379883591802309436296952391095072451682898295326420175855826842055175106223332963408689731703091918633163278380082673666261570758547885869757099892791042939968252361627065358031930684701800165215603974431058727950227350482935523344814955671480327252979643359630323554444988276491406184288650094448982372164666468728502091212086430137821008594207925756957139946125970032910742975053945553646686318141686253173297226435982351456290515670335803358633818947605651206324304939113256615195519471339312834316755394573060772371790623106774303792050357292197348297644061648802495006292054577545983796418125248433869697165578129541646538807189005183007486214312576282342841134318914954511112989512075456347055876474645680733350015995531232748687322435402826882309389849587713111202530174074091838979714089215669774764215717188763471995956010794639474029315139939385225945277106968666714210297514217496996185321330084759546423210875495529023226116811883615960837181611238213362280557367617954479119024513597601241907446892233158873631242469698433717614158661600590316696647316886589678652123305184116624786980021462341705410563860947279039300737806972455520897287257638024238364516926154904115412878878856263024783474075827796841381539273786216000359850928159035780166374617271838565001832313977270577206899964830418618507002312336522337939408701042024019137490941028539266193158282291329779144344995014016590593488809661639648779896090319134886907174453672966068511964878809266674037603320574078235934285493627867713953922729914980405062934824986432420282731051552766108293074021862571238436703889543148527325701169284604195160109782910646612549752635544999022620939193993186404051918348857774252543060636642571896618042304750054495598880640692092578537590860626707079002154733148502133189339264181240886176765693449142104590022745703094245886155678205943013395327948433675033383336476104345464302416203348963541062149615059863385852982816055549749778467960898427243241364844004541068214985562417744346087730252440217796383150096544520406171830856168156526145684984590008903003476193303582840886445439335570610300308941880021323821827638708698008099423618013081059580887819126348271036966969809077424836775059146929653963515535554947304990906055112156164962032211101830029507958016750822085923984290761528341661201495599462222584725929124842155739533086511588550075372158751519059880885288569915223838284512060513119721775321465697610758275291032678124356948969175177866932672923110390640163306998319180956053928034541860214023030105571149755525221460639893606591041504629838935694246477042858368282273265020101114684038007602376063907175790861626239886845353466908596514518767934630089841480729800124015208949043546509131188147023300438560570297230172603254188660078753610498865716338756378880936033478065550908866945987377890415476912948523604644497234202054497264866996660026074106879390912451653785703394996138631061245598236313780234473982177071295392682555654871705858655790651097464897385402816492563501841286624920260070143766601750869331483302779246994187046837770497382754602532044661122319185225448192049723086315160428975992216599871616759476944931400813404801737341653045712975174767077642917037971274159919308531306071014166678640053464446672020095458338448474484738761016821799922422228133172290113186481272462860821825571826200500911201795814734926905583003226716568860603451386691400312879450670360708590805089091102850423040665884599029981657306044493713473640565178798129420960441254402527801326399966558743536802107017367971808212772661177475472370657886817873950767865144309001199271799393410448597044424936263257977037296824274054900474619138049451311470509256033691879790954983096425721289650793213358243118118439750209617679146564250752322848678619677587399145397371704815890713879219248308828793248764147209756361294852817288191156745224437076795273501593026517877380580545673375342291610283092813352422243650120234079101082113477201811091521981746773522110391144133089534238160263004810574311209095372311032089010564738389492070571240102216519646469247431204937102755016063998612937179275043304984799127528131691714798236851921700355483165127536766132237590093009107455781473378207042434755384487085916530175843248796013795137393382102903073266745830834982484563931990653523307165014275274409375866415044339952805732769730729534413166944116169315649002534016796812448834743962644404466781357613559028474044755865983827833968851002793935088223383573750998848227413280971529475689141682243570247795892913015765181482261058632619598398069564634146864645831730309098233184535946714124462939414280700495958124135154980256248708653823303358187780617912552468636796653307834796427191947649708096780602809065028211823246264996700323870460528822542701985043672015632990012537026401338399108661844039278460851419402999604258781089766196883581255846533619559820632671366890244107607089937098457594014733588836926483026780969401957352109157952828670100998070783338961977359895123358931071415792564681034976337250630942325817848313063941374745726932035556711680559679679338885091121306119392219824540038310183946874294047015653825943003295253201450368432541783294694420663169601710510466518576509966935233462927646950658075430631846519145950987039204293360492987461105262297012183890951197379045227954639385105270189315464866228214687288413068921925573964253490883789483080261496875971139959921740509283654099339457957272903564802983529542029880596526495005928547836794406474710933393183265270120109745498996316365207973064861746944922292110729521654400686841354427798286000064155801306185388292676434793263184318955076239502184256900042077641713404467568861762750477078858777064935427487592046750492018632948171351567540912920034061121357187615264334396517123039693580580327794736528511545202515152594773798358606955913593987565938036697466428454846502016108034414242085699604218899286254304831103484021555794083327632901292302104173268858986800053346922298676089945273968077731907767375694429355660536919489397316641138956711743405100544288907863514091961675384441283966275145406201003064576859498681934667411725417383258924069218550933045109305972224518815323049914775776711267362575852210475423786663797851116759641063660744865874318967262810894695506768199797687324037533391055333349398002287168341391866731217398226556451348651779274395454696889525660344448030430153522877464590764217242479679410761410854399584354827912711285022841772338791931741491672753966964249088019087432911189282901856170692330656873772695300452785504412385995443317361415152002248568727032055793541950535269685264412928799323071793904226772454949826479060775934192459871186272878806757130975219564274163577059158467075676125643354136120732561579773727206857298476566110606371477124902752601181326632923616465685001680634480599428333637860153302215166708054165773540503134913332110984094213589057533180371853906887109785905122357076663421135902253486742686248873822666740114362576632060371018218142169889410201827139187364589647056312748520016351779679060928039305761522079540458898682948810171619533268770473826767944485761139410130564715048395099813710759415250423642337894310724263954722008592948274483501157358209859482480776432526226576863519347966292932715313277369141445313396608710326651866991284863981563225370118385107070649904322983104762537057471203563374519864998450991945944766422599657688636978099327616874128291209434072661197032387402273418096817296619297510825174395629046351940885251814968846344128186329580924333478760678415602077805101049128739273718428739749454204335633478241881918582690777391837313700698603871915339119959818398707148280817960976581850056336882152447003111156693528442807617427664414123293834700558991147380288482701340616986941773640057231647080611061046419885147914690663423041074016571729649086985655550939382299743894629357663905219407220857654468236007800234469616128260199625031872559648718115776558840838767409940507373647299953866769690763096557152831889336458457511285964808915819332845835742682143178974195448745818593514639403033027713958904673956106011925178506641501279691466298288405343304517371411620569213771333580054684165302115075059519537291632857301907773615253266699605249717534990991191847930433211947590102789178045903530747855477853914700657847416525906778974867430225358688811617594194290535168284416124400277826944342949846097518840061751970315237062523076109574281860707804120285867303509165817646957589310164305990329303307092697212115088679684201104568670064041450342430378443678042987528492191531806128516022972849775980119927920982756633528126295364289186138702172506235259156824418231232763081638890553417161282081839234852099986193063204576027069186951016271636437284789829136095905163226816673475496236256651885739708421131816894058936329114076313257267421156241609467095310356062171112890975401081490892515612964688833504407482308526355847756229009615354257810610235809256464338523069841406259293073932019133136697081124957844808627025441145488615781235513113672532378077658914960966325179090161733811459768893809967554113873211269593494482687425547556607301335482205931760790611146752091981314991507765871383750086788531576643063786534149453173003127827957633812879956978436499370096558668380277587541000969871098227961671533677374853577317279139050998429653862719490105389615648523110802461305424317147187059800650970843374117866333600164093804359920981388399456441815099690266041661886617956590280094435845515210952573237965290352041269628620668126834502391633497342396846786718240474273090670657859148357272298513511248043650179227406786388313002684777820517142105250915131166150859545973223746221516127272239775710811363504062263879079025683067451416153832485922187978736594497429012771710168780801636250282198371308455699624648784857426303454240325917528578062515626067163217256289427299872412044933389706384254207132560178357605178085856051425149764324386512760419532614585692236571719342881045558320964625206633631699971763694035890420147239617838756196445003012519815070362846172113292663671568549115094966269962672584076044191240097241609922096131020109851060010721683918277197154587492244007295633243180220963956528933542491381441710862677999169145091677589116711288717248138797094983815914310934235714894792441134971533547183623444551883943680938415484174796332152068388454695688004175496085069606302650524422398463718944074683640916258231136321899515260012676132899926262285588317096136066264814651637894831465163822616384929440327745461977064490075302408799699011363798840592849043721229450486888967190894960245921686640472884295673634697047641431727431251688590556932934020177922496669038075136228428955466831529768725930313908300697589233840497669057928898669175310046449831738166073048418962301109439590706285458666624242776782347082308124970120259533815311940147370779918005772089584423047615960536427076734740727048491026835313470350880426603936511010527330134654659997732100498036846577003880236317304874521538330684222414117001386078151361610163246745666209258827081699215730833814012547954630525045705118591825074377282610437354544177526948975352497920806742986781953542829405131078507731838620855813367264184757230941933491080464001547206409588613459626749441768419880539355670548717680979823633046805502066225723301936329483937673051683717655948748268035335896839748676372144999236941761471336933289205800957717773471589526579042878939890754911886896316242681010645286670674233082293805684866117890144315882348668578447713310295432901040607248532395544747645746438430801743591733531315678917442762163623699606355478135763424951410684611158980222061950103880095459782343342631368338036312240861145528696342505161162970331933370167559255264316526562698456690749543485233699784069854044565389793128676349864604982207446289361032494148150052155553468726712188112554087930911695543785665306459544448225910993607033659022250745340395298607373268845542978153605666641683893481211642887449166321118604762714273681319447057502006196300371531963206718379172291339159851457953993685852502584587736622194448858119194865955228391705942196912865546721840965852626096080936143368752183930347385002667363891635785046349707252721898893169050753136826085459225363699778019919891710232220813990397960915993367688110174334696630061018712392152649223216326744074710498574402352276153977273224568905222607365379286747324377388041278283524917592200235882559925667631635909326102751123600737422649587122305077034338102860020266000272774418662371523708288498260466603620063927481705034333814740588058633100430511509962131069820100371441344914582459898445255803220070619647223388673101949990109274468330610649163485351342564190051857945448903202133467680393888767193482463528758298788887857436691408074523574790294368246484947906057259459705940673022529072164384238014523337215175653773831314998222994063923036664835222909118883581425377461773265349088046411053441451241486621243295178939650500713488655002799201043942565097236106458295959121375414170529321526652206700279781813681447132945139051509363668414159928712496864340446202813860525835182799726334172032379136965684835366339696686110344124000382976185285665599389529476548198273157678385516909691816561970553799162093749148124375681516941025169418165910082579354039215306036554571061518783893000391475500479669963018107246608622793067416211021927004280031690782280285715422075103416570169701606471079571405119850999925273917935517663431057693386590987233651816979776523930933448358055583763855933069281966180498081072865005747685441225291181116892541718762199069577163661570037850518606693764515766516194873079496232514789754091446591506463824023034461747008389522772466781255118666706814701077169515196255580082898070372203391117829318284837379954589421366585181362975116406078159560776417989651117306135820103641742146262037810004972956802862035553754437813532765901188938840338051549249028419157646411433296937086466740741192714784491344454229165747067462047843332951986124056471574003541166884688893515157428746508622050708469402741092510149070282362509293981158842249613801091895038139989354612146406757334107172281163046139965188489868024131286016647634347209150467190527113426054034984053958531033967242645197132871079120315464819194673135325716051137751995178556095283646362992934180210845942155622860431785161812505977868034224978742084869096491755064920218913751740232642192444528599641991969060587997216580494843614674431921974078855616150614137563681696390796670528835490958738410014250197394421811259273187165262759512309729871851702328968409955309415086738113729880194408790741090490037641522483709887595157666343703053132657833237764047629851712691251057399908736495943292564422608132632758689302207000980686888097934726562500347404886779052055686592181313176575705775969064940198567602975177060472995546789169380068534535884566257118619363670222467768624035019692225837555577002809118656703179269893962377392126320055540024672142735714097373072713051092413883743508564223453433513100493406311890176970588077464783083413169143936657922720252282246937621195051488348990126775358244287713947064934304298345691951156327885418194758847516668805301494780207654959777429904847058409676846041154724414637972189743522075797996179024899336012555300908785226167700375923254654272534946930703011144801613337838015113063451162211928963895830337606076027249405541975651952078301345382777476576773631227594868322243516745893018006149263135317038316763500044657755653000209599320535331250149009352634743913710080038914566954592158374689754748417662540517257844628498003047450673567272995083933314485910619535624472764088337201777765506737258752513357618632510848983449417409620678878309775552743760009328351073036465985055809752388354167569569832209767358530796108367971678936835298244118597744125496813910597250344624970867912904582043600143916345722402264302056037153075537049979071877146086643819805494706276736992221699036220456921450126534835764280242663199475104918807776737855232865000114673464359964501768755828820943952528927373713557095623762820657271973518302495795919953980108457344546783901615852952140813285016555809417054421638659053461517460019336253134576283917705701952430630499265562082214340413744655878992116573940649494828290138497450113668835283978396643718977554127430066795444795175070094958596008949376935634234924607842550471539250951519744604871717451146506918580080018656424943875840093133538679710636247117507861851685696363598820297685761151204395076437355827134006085754558083385611356610953557813586463470601120490667091245553287144500520124991392615513762895999266278256033335495387221528746079885719378626155761844028403585753070445186512154918854082759931930938564136367347010751553333638516873900602357009677988055021423469098473087126632378993541831754767208794934924842788469709363847610493338360561247710830133010131862849192905277551225738072278313419087402445554812391109213679983237147819071971345792929823233209927063842945200552905319928279071782736559074582951425853187766726873017134060498346255712724565679745542120525771681195349009715265115997015205837586220906648274025477583451163281128159008540275088774659468049863316709033609296019756659797550006297653187817965196751254725913781810608983698819224888957522514360681553163543370606992510493008890947587254887807877656502917939700383007859512042405122238320186335058474834714651250087329898729178441796317941202848718861881097823785790461645885304963742391397357803309066452019855060263109890883571965576639308815696093667708281368973684162832918838461298359931745142218159886801379167

;;
;; Its works! (I think...)
;;
;; The answer is different (somewhat) from the answer generated by MIT-Scheme
;;

;;
;; It's interesting to note that this is the same answer given by the following Haskell code:
;;
;; millsIter x t | length x > 0 = millsIter (tail x) ( (cube t) + (head x) )
;;               | otherwise = t
;;
;; millsIter a 0
;;
;; where a is set to the list as in the Lisp code.
;;

;;
;; It is also worth noting that many of the steps in the iteration generate prime numbers:
;;
(def mills-1 (list 0 2 3))
(prime? (mills-iter mills-1 0))
;; ==> true

(def mills-2 (list 0 2 3 30))
(prime? (mills-iter mills-2 0))
;; ==> true

(def mills-3 (list 0 2 3 30 6))
(prime? (mills-iter mills-3 0))
;; ==> true

(def mills-4 (list 0 2 3 30 6 80))
(prime? (mills-iter mills-4 0))
;; ==> true

(def mills-5 (list 0 2 3 30 6 80 12))
(prime? (mills-iter mills-5 0))
;; ==> true

(def mills-6 (list 0 2 3 30 6 80 12 450))
(prime? (mills-iter mills-6 0))
;; ==> true
using System;
using System.Text;

namespace NCS.DSS.AnonymiseBackup.Helpers
{
    public class AnonHelper
    {

        public static string[] Forenames = {"Malia", "Tomasa", "Lyndon", "Debbie", "Ebonie", "Kristle", "Barney", "Darrick", "Dorthy", "Hertha", "Issac", "Jaimee", "Dawne", "Terica", "Maurita", "Corine", "Louie", "Isiah", "Delsie", "Genie", "Cassy", "Fanny", "Heike", "Nina", "Kira", "Aiko", "Alesha", "Emery", "Latesha", "Mamie", "Holley", "Karisa", "Roxana", "Oretha", "Karri", "Suzi", "Dave", "Oralia", "Sharee", "Camilla", "Quentin", "Shantell", "Ronald", "Leonor", "Yong", "Josue", "Nadine", "Carmine", "Lynetta", "Opal", "Yee", "Tiana", "Junko", "Berniece", "Jeremiah", "Leena", "Bernadette",
            "uann", "Kera", "Arthur", "Gretchen", "Aurore", "Lowell", "Reva", "Angelo", "Jess", "Callie", "Georgette", "Odessa", "Ricky", "Penny", "Dale", "Maribeth", "Blanch", "Dean", "Wilson", "Andrea", "Geraldine", "Adeline", "Kathrin", "Venetta", "Lila", "Donnette", "Honey", "Maxwell", "Erna", "Carolynn", "Jarred", "Prudence", "Sima", "Brice", "Dovie", "Vaughn", "Anitra", "Lesa", "Rhonda", "Jena", "Danyel", "Loma", "Winnie", "Neoma", "Millicent", "Willa", "Diane", "Zackary", "Theodore", "Song", "Demarcus", "Candida", "Carline", "Shaniqua", "Irma", "Yee", "Kanisha", "Mikel", "Lorelei",
            "Maureen", "Mariano", "Genevieve", "Shelton", "Tyron", "Tyesha", "Eleanor", "Jill", "Tifany", "Hellen", "Jenny", "Carmel", "Lyndon", "Janie", "Janyce", "Sierra", "Sharita", "Terrie", "Daniella", "Christian", "Dena", "Isabelle", "Carmelina", "Bennett", "Camilla", "Madalyn", "Carin", "Merna", "Cindy", "Shandra", "Thi", "Shala", "Nickolas", "Lidia", "Louella", "Cristina", "Marlys", "Treva", "Jerrod", "Waltraud", "Domenic", "Michell", "Ronda", "Denny", "Mi", "Rosann", "Ruben", "Beckie", "Gwyn", "Ashley", "Tish", "Carli", "Shanell", "Lakeshia", "Edith", "Darin", "Shaneka", "Sharon",
            "Nelson", "Kaila", "Alfonzo", "Florene", "Rowena", "Lawrence", "Shayna", "Tobias", "Maribeth", "Rusty", "Jammie", "Arden", "Paulita", "Mauro", "Shelia", "Tiffiny", "Pauline", "Tyron", "Shaquita", "Tiera", "Rozanne", "Shizue", "Buford", "Beulah", "Piedad", "Abel" ,
            "Aaron", "abby", "Abednego", "abigail", "Abner", "Absalom", "Adaline", "ade", "Adelaide", "Adele", "ADO", "Adolphus", "Agatha", "agnes", "Alan", "alastair", "Alberta", "aldrich", "alex", "alexandria", "alfonse", "alfy", "algy", "alicia", "alison", "Allen", "Allisandra", "Almena", "Alonzo", "ALPHUS", "Alzada", "amanda", "AMOS", "ana", "anderson", "Andrew", "angel", "Angelina", "ANGIE", "anne", "annie", "Anselm", "ANTOINETTE", "Appie", "appy", "Ara", "ARAMINTA", "Archie", "arie", "Arilla", "arlene", "armanda", "Armilda", "arminta", "ARNOLD", "artelepsa", "Arthur", "Asa", "ASAPH",
            "Athy", "AUDREY", "augustina", "Augustus", "AURILLA", "AZARIAH", "Bab", "Barbery", "barby", "BART", "Bartholomew", "Bat", "BEA", "Becca", "BEDA", "bedney", "Belinda", "bella", "benedict", "BENJY", "Berney", "Berry", "Bertha", "BESS", "Beth", "Betty", "beverly", "biddie", "Bige", "billy", "Blanche", "BOB", "boetius", "bradford", "bree", "brian", "bridgit", "Brina", "Broderick", "brose", "Bryant", "cage", "caldonia", "Calista", "Calliedona", "Calvin", "cameron", "Campbell", "Candy", "CARLOTTA", "Carmellia", "Carol", "caroline", "Carrie", "casper", "CASSANDRA", "catherine", "cathy",
            "Ced", "Celia", "CENE", "char", "Charles", "CHARM", "CHAUNCEY", "Chesley", "Chet", "Chloe", "Christa", "christiana", "Christopher", "CHUCK", "Cille", "cinderlla", "cissy", "CLAES", "Claire", "Clarence", "Clarissa", "Cleat", "clem", "cliff", "Clifton", "COCO", "COLIE", "con", "conrad", "CORA", "COREY", "cornelia", "Corny", "COURT", "Creasey", "Crys", "curg", "Cy", "Cyphorus", "Dacey", "DAISY", "DAN", "DANIEL", "Daph", "DAPHNE", "Darlene", "Davey", "Day", "Deb", "Debby", "Debra", "Deedee", "delbert", "Delia", "Delius", "della", "delores", "DELPHIA", "demaris", "Denise", "Dennison",
            "deuteronomy", "DIAH", "diane", "Dick", "DICKON", "Dicy", "Dilly", "DITUS", "dobbin", "dolph", "Domenic", "Don", "donny", "Dora", "Doris", "dorothy", "Dosie", "dot", "Doug", "dre", "Drew", "DUNCAN", "DUTCH", "Dyche", "Earnest", "EBEN", "Ed", "Edgar", "edith", "edmund", "Eduardo", "Edwin", "Edyth", "EFFIE", "Eighta", "elaine", "Eleanor", "Elena", "ELI", "Eliphalel", "elisa", "Elizabeth", "Ellen", "ellswood", "Elminie", "ELOISE", "ELSEY", "elswood", "ELWOOD", "Elze", "Emeline", "Emily", "emmy", "eph", "EPSEY", "eric", "ERIN", "Ernestine", "ERWIN", "Essa", "Essy", "ESTHER", "Etty",
            "Eudoris", "Eunice", "Eurydice", "EVA", "evan", "Evelina", "exie", "EZEKIEL", "Ezra", "FATE", "fel", "felicia", "Feltie", "Ferbie", "Ferdinando", "Fie", "Fina", "flo", "Flossy", "Ford", "frances", "Francis", "Frankie", "FRANKY", "franniey", "Freddie", "Frederica", "Frieda", "frona", "frony", "Gabriel", "Gabrielle", "Gay", "gene", "Geoffrey", "Georgia", "Geraldine", "GERRIE", "Gert", "Gil", "gina", "GLORIA", "Governor", "Greenberry", "Gregory", "gretta", "Grissel", "Gus", "gwen", "Hal", "Hamilton", "hannah", "Harold", "harry", "Hassie", "Heather", "Helen", "Heloise", "HENRY", "Herb",
            "Herman", "hessy", "hetty", "hiel", "Hiram", "HOB", "Hodge", "Hody", "Honora", "Hopkins", "horry", "hosea", "Howard", "hub", "Hugh", "ian", "Iggy", "ike", "Ina", "Indy", "Iona", "Irvin", "Irwin", "Isabel", "Isadora", "Isidore", "ivan", "IZZY", "JACKIE", "jacob", "jahoda", "JAMES", "Jan", "janice", "JANNETT", "Jay", "jean", "Jeannie", "jebadiah", "JEDIDIAH", "jefferey", "JEFFREY", "Jem", "Jennet", "Jenny", "jeremiah", "jess", "JESSIE", "Jim", "Jimmy", "jinsy", "JOANN", "joanne", "joe", "JOHANNA", "john", "jon", "Jos", "Josephine", "Josey", "josiah", "joy", "JUANITA", "Juda", "Juder",
            "Judie", "JUDY", "Julia", "Julias", "Junie", "JUNIUS", "Justus", "KAREN", "KASEY", "Kate", "Katherine", "Kathryn", "Katy", "Kayla", "Kendall", "Kenj", "kenna", "kent", "Keziah", "killis", "Kimberley", "King", "kissy", "Kittie", "Kris", "KRISTEN", "Kristopher", "L.B.", "laffie", "Lamont", "LANNA", "Laodicia", "Laura", "Laurie", "lauryn", "Lavina", "lavonia", "Lazar", "Leafa", "Lecurgus", "Left", "Lemuel", "Lenny", "leo", "Leonidas", "leonore", "Leslie", "Lester", "Lettice", "Levi", "Levone", "Lexi", "Lib", "life", "Lil", "lillah", "lilly", "lina", "lindy", "Link", "Lish", "lissia", "LIVIA",
            "liza", "Lodi", "lola", "LON", "Loomie", "Lorenzo", "Lorraine", "LORRY", "LOU", "louis", "Louvinia", "Lucas", "Lucias", "lucinda", "Lucretia", "LUKE", "lunetta", "LUTHER", "Lydia", "Mabel", "Mack", "maddy", "MADGE", "madison", "magdalena", "Maggie", "maisie", "Malachi", "malinda", "Mamie", "Mandy", "Manoah", "mantha", "Marcus", "margaretta", "Margery", "margo", "Maria", "MARIAN", "MARIE", "Marion", "Marissa", "marsha", "Martin", "marty", "MARVIN", "Mathew", "Matilda", "Matthew", "matty", "Maureen", "mavery", "max", "Mc", "Meaka", "meg", "mehitabel", "melanie", "Melinda", "Mellia", "melly",
            "Melvin", "Menaalmena", "Merci", "Merv", "mervyn", "Meus", "Michael", "Mick", "MIDDIE", "MIDGE", "millicent", "Milly", "Mina", "Mindy", "minite", "Mira", "Miriam", "mitchell", "Mitty", "Mock", "Molly", "monica", "Monnie", "Monteleon", "Monty", "MORRIS", "MOSE", "MOSS", "Myra", "Myrti", "NACE", "Nadine", "Nan", "NANDO", "Naomi", "Nappy", "NATALIE", "Nathan", "natius", "ned", "nell", "NELLIE", "nelson", "NERVIE", "Nettie", "newton", "Nicey", "NICIE", "Nicodemus", "Niel", "nikki", "noel", "NOLLIE", "NORA", "norbert", "Nowell", "Obed", "OBIE", "Ode", "Odo", "oliver", "ollie", "Ona", "Onicyphorous",
            "Ophi", "Orilla", "OSAFORUM", "OSSY", "Ote", "OZZY", "Pam", "Parmelia", "Parthenia", "Pate", "PATRICIA", "Patty", "Paula", "Pauline", "Peggy", "Penelope", "PERCIVAL", "Peregrine", "Perry", "PETE", "Phelia", "PHENEY", "Pherbia", "Philadelphia", "PHILETUS", "Philipina", "PHILLY", "PINCKNEY", "PLEASANT", "POKEY", "Posthuma", "prescott", "Providence", "prudence", "Quil", "Quillie", "Rafaela", "RAMONA", "Raphael", "ray", "Raze", "rebecca", "REG", "reginald", "Rella", "Renius", "retta", "RHODA", "rhyna", "Riah", "rich", "RICHE", "ricka", "ricky", "rissa", "Rob", "robert", "Robin", "Roderick", "Roge",
            "Roland", "rolly", "Ronald", "Ronnie", "Rosa", "Rosalinda", "ROSCOE", "ROSEANN", "Rosie", "ROSS", "Roxanna", "Roxie", "RUBE", "Rudolphus", "rupert", "Russell", "Ry", "Sadie", "SALLY", "Salvador", "samantha", "SAMSON", "Samyra", "SANFORD", "Sarilla", "savannah", "Scottie", "Seb", "see", "SENE", "Sephy", "SERENE", "sha", "Sharon", "sheila", "Shelly", "Sher", "Sheryl", "Shirley", "sibbie", "sid", "sigfired", "sigismund", "Silence", "simeon", "Sina", "sis", "Smith", "SOL", "Solomon", "Sonny", "SOPHIE", "squat", "Stal", "STEPH", "stephen", "Steve", "STUART", "SUKEY", "sulie", "Sully", "susannah",
            "Suzie", "Sy", "sydney", "Sylvanus", "tabby", "Tal", "Tamzine", "tanny", "TASHA", "TAVIA", "TEDDY", "Temperance", "Tensey", "terry", "Tessa", "Thaddeus", "THANEY", "THEODORA", "Theodosius", "Theotha", "Thirza", "THOMAS", "Thys", "tick", "Tiffy", "Tillie", "tim", "tina", "TISH", "Toby", "TOMMY", "Tory", "Trannie", "Trina", "trix", "Trudy", "Uriah", "Val", "Valeri", "Vallie", "Vandalia", "Vangie", "Veda", "Vernisee", "Veronica", "Vest", "Vet", "Vicki", "vicky", "Vicy", "Vina", "Vincenzo", "Vinnie", "VINSON", "virdie", "virgy", "VON", "Vonnie", "Wally", "walter", "webb", "wen", "WILBER", "wilfred",
            "Will", "WILLIS", "WILMA", "Winfield", "winnet", "WINNY", "Winton", "woodrow", "Yeona", "Yulan", "zachariah", "zada", "Zadock", "Zeb", "Zedediah", "Zeke", "ZEPHANIAH"
        };

        public static string[] Surnames = { "Smith", "Jones", "Taylor", "Williams", "Brown", "Davies", "Evans", "Wilson", "Thomas", "Roberts", "Johnson", "Lewis", "Walker", "Robinson", "Wood", "Thompson", "White", "Watson", "Jackson", "Wright", "Green", "Harris", "Cooper", "King", "Lee", "Martin", "Clarke", "James", "Morgan", "Hughes", "Edwards", "Hill", "Moore", "Clark", "Harrison", "Scott", "Young", "Morris", "Hall", "Ward", "Turner", "Carter", "Phillips", "Mitchell", "Patel", "Adams", "Campbell", "Anderson", "Allen", "Cook", "Lawson", "Day", "Woods", "Rees", "Fraser", "Black", "Fletcher", "Hussain", "Willis", "Marsh", "Ahmed", "Doyle", "Lowe",
            "Burns", "Hopkins", "Nicholson", "Parry", "Newman", "Jordan", "Henderson", "Howard", "Barrett", "Burton", "Riley", "Porter", "Byrne", "Houghton", "John", "Perry", "Baxter", "Ball", "Mccarthy", "Elliott", "Burke", "Gallagher", "Duncan", "Cooke", "Austin", "Read", "Wallace", "Hawkins", "Hayes", "Francis", "Sutton", "Davidson", "Sharp", "Holland", "Moss", "May", "Bates", "Bailey", "Parker", "Miller", "Davis", "Murphy", "Price", "Bell", "Baker", "Griffiths", "Kelly", "Simpson", "Marshall", "Collins", "Bennett", "Cox", "Richardson", "Fox", "Gray", "Rose", "Chapman", "Hunt", "Robertson", "Shaw", "Reynolds", "Lloyd", "Ellis", "Richards",
            "Russell", "Wilkinson", "Khan", "Graham", "Stewart", "Reid", "Murray", "Powell", "Palmer", "Holmes", "Rogers", "Stevens", "Walsh", "Hunter", "Thomson", "Matthews", "Ross", "Owen", "Mason", "Knight", "Kennedy", "Butler", "Saunders", "Morrison", "Bob", "Oliver", "Kemp", "Page", "Arnold", "Shah", "Stevenson", "Ford", "Potter", "Flynn", "Warren", "Kent", "Alexander", "Field", "Freeman", "Begum", "Rhodes", "O neill", "Middleton", "Payne", "Stephenson", "Pritchard", "Gregory", "Bond", "Webster", "Dunn", "Donnelly", "Lucas", "Long", "Jarvis", "Cross", "Stephens", "Reed", "Coleman", "Nicholls", "Bull", "Bartlett", "O brien", "Curtis", "Bird",
            "Patterson", "Tucker", "Bryant", "Lynch", "Mackenzie", "Ferguson", "Cameron", "Lopez", "Haynes", "Cole", "Pearce", "Dean", "Foster", "Harvey", "Hudson", "Gibson", "Mills", "Berry", "Barnes", "Pearson", "Kaur", "Booth", "Dixon", "Grant", "Gordon", "Lane", "Harper", "Ali", "Hart", "Mcdonald", "Brooks", "Ryan", "Carr", "Macdonald", "Hamilton", "Johnston", "West", "Gill", "Dawson", "Armstrong", "Gardner", "Stone", "Andrews", "Williamson", "Barker", "George", "Fisher", "Cunningham", "Watts", "Webb", "Lawrence", "Bradley", "Jenkins", "Wells", "Chambers", "Spencer", "Poole", "Atkinson", "Lawson", "Bolton", "Hardy", "Heath", "Davey", "Rice",
            "Jacobs", "Parsons", "Ashton", "Robson", "French", "Farrell", "Walton", "Gilbert", "Mcintyre", "Newton", "Norman", "Higgins", "Hodgson", "Sutherland", "Kay", "Bishop", "Burgess", "Simmons", "Hutchinson", "Moran", "Frost", "Sharma", "Slater", "Greenwood", "Kirk", "Fernandez", "Garcia", "Atkins", "Daniel", "Beattie", "Maxwell", "Todd", "Charles", "Paul", "Crawford", "O connor", "Park", "Forrest", "Love", "Rowland", "Connolly", "Sheppard", "Harding", "Banks", "Rowe",
            "Weeks", "Forde", "Millward", "Waldron", "Brookfield", "Gibb", "Eden", "Wilkie", "Hickey", "Chilvers", "Partington", "Pallett", "Manning", "London", "Karim", "Kelsey", "Knox", "Bamford", "Halliwell", "Moorhouse", "Duke", "Mack", "Hyde", "Bedford", "Nott", "Mullen", "Hodgkinson", "Locke", "Wild", "Mctaggart", "Chauhan", "Squire", "Ramsden", "Maher", "Waugh", "Shipley", "Chalmers", "Broadley", "Walls", "Algar", "Groves", "Pryor", "Valentine", "Chan", "Donovan", "Nunn", "Warburton", "Milward", "Gooding", "Marlow", "Laycock", "Glynn", "Gaffney", "Ricci", "Pollock", "Craven", "Goodall", "Downs", "Borland", "Hatton", "Rush", "Prevost", "Pond",
            "Harley", "Crabb", "Darcy", "Dobson", "Collett", "Corr", "Rothwell", "Lewin", "Crowley", "Leek", "Bowles", "Windsor", "Eales", "Lawler", "Jacob", "Sadiq", "Smallwood", "Masters", "Dougal", "Hewlett", "Darlington", "Mcavoy", "Underwood", "Drury", "Waterhouse", "Hussein", "Gorman", "Haddock", "Mathews", "Mckee", "Strachan", "Mcgrady", "Clough", "Marr", "Marks", "Riches", "Sugden", "Pickett", "Farr", "Elder", "Tuck", "Lomax", "Judd", "Wakefield", "Tang", "Foran", "Blakey", "Mistry", "Beer", "Mansfield", "Parks", "Blythe", "Rashid", "Corcoran", "Kumar", "Kinsella", "Brooker", "Peck", "Rowlinson", "Fairhurst", "Southgate", "Harry", "Bower",
            "Ricketts", "Butterworth", "Toland", "Mccall", "Swales", "Woodford", "Hoult", "Head", "Winstanley", "Emerson", "Coburn", "Rutherford", "Radford", "O dell", "Floyd", "Speed", "Featherstone", "Chappell", "Polson", "Spicer", "Crosby", "Lilley", "Worrall", "Toms", "Prescott", "Lunt", "Lester", "Phelan", "Montague", "Egan", "Fallows", "Rainey", "Steward", "Hurrell", "Hitchcock", "Aitchison", "Beatty", "Dick", "Clifton", "Forshaw", "Mcbain", "Walkden", "Machin", "Burge", "Boon", "Howes", "Makin", "Patton", "Maynard", "Tovey", "Deane", "Reading", "Wheeldon", "Warden", "Exley", "Stock", "Jobson", "Fell", "Mccullough", "Foulkes", "Milligan",
            "Heather", "Tipping", "Hamnett", "Mcdonagh", "Mcshane", "Moroney", "Keeley", "Brelsford", "Dack", "Whalley", "Inman", "Odonnell", "Street", "Alves", "Wraight", "Fitton", "Eadie", "Thom", "Rutter", "Deakin", "Tobin", "Farrar", "Gascoyne", "Shand", "Mccourt", "Coward", "Leggett", "Graves", "Fairlie", "Redding", "Rafferty", "Mcgee", "Magee", "Mallinson", "Mears", "Davenport", "O connell", "Harker", "Tweddle", "Showell", "Millett", "Stedman", "Worth", "Sturgess", "Madden", "Shea", "Sherman", "Bayliss", "Veitch", "Rowan", "Heron", "Whitham", "Alder", "Eddy", "Roscoe", "Finn", "Leal", "Edmond", "Last", "Collingwood", "Hopkinson", "Ainley",
            "Vince", "Macintyre", "Hennessy", "Llewellyn", "Parish", "Montgomery", "Haslam", "Coulter", "Gillett", "Snowden", "Burr", "Rushton", "Finlay", "Malley", "Slade", "Gaynor", "Westwood", "Brooke", "Dodds", "Prior", "Osman", "Strange", "Giblin", "Batten", "Lander", "Sayers", "Mcfadden", "Orchard", "Baron", "Benjamin", "Ritchie", "Ransom", "Heywood", "Townend", "Friend", "Ansell", "Gleave", "Boulton", "Hogan", "Fryer", "Garrett", "Moriarty", "Leith", "Court", "Hampson", "Radcliffe", "Styles", "Stringer", "Purvis", "Mortimer", "Johnstone", "Galloway", "Tolley", "Hooton", "Macarthur", "Burford", "Cheung", "Woodhouse", "Rouse", "Healey", "Hallam",
            "Steel", "Sturrock", "Abel", "Mcauley", "Bacon", "Downie", "Glass", "Ewing", "Mckie", "Oldham", "Swann", "Dubois", "Cummins", "Lunn", "Lightfoot", "Higginson", "Garrard", "Latham", "Brain", "Wale", "Aslam", "Coffey", "Luke", "Alderson", "Good", "Costa", "Compton", "Hinton", "Main", "Crook", "Keane", "Batty", "Darby", "Fischer", "Mottram", "Collard", "Biggs", "Manson", "Mathers", "Stannard", "Moffat", "Kershaw", "Isherwood", "Smythe", "Tailor", "Meakin", "Raeburn", "Swain", "Truscott", "Snow", "Cann", "Jardine", "Aston", "Longhurst", "Harman", "Gower", "Connell", "Keay", "Khalid", "Burman", "Pickard", "Sissons", "Ashworth", "Dowell", "Durham",
            "Flanagan", "Cavanagh", "Sewell", "Oates", "Creasey", "Sands", "Hine", "Cheshire", "Houston", "Michel", "Waterson", "Langton", "Sisson", "Metcalf", "Bristow", "Tyrrell", "Mcclymont", "Littlewood", "Steere", "Symonds", "Mace", "Cove", "Simms", "Myatt", "Horrocks", "Fairbairn", "Emmerson", "Cowell", "Symes", "Molyneux", "Said", "Dandy", "Bethell", "Hickman", "Turrell", "Paisley", "Kell", "Budd", "Winn", "Dawkins", "Linley", "Mcguinness", "Hawkes", "Murrell", "Doble", "Pointer", "Sharkey", "Bugg", "Hurley", "Fish", "Ashby", "Dufour", "Maddocks", "Sherry", "Hoyle", "Beadle", "Ring", "O doherty", "Garbett", "Snell", "Elliot", "Cotterill", "Cahill",
            "Bingham", "Stark", "Doran", "Tilley", "Maclean", "Allwood", "Tennant", "Caddy", "Matheson", "Carling", "Lawther", "Laird", "Oxley", "Mcginty", "Bill", "Kingston", "Lock", "Kendell", "Burdett", "Stout", "Hutchins", "Allard", "Chapple", "Mawson", "Down", "Gilmore", "Attwood", "Parmar", "Snowdon", "Mcgrory", "Laverick", "Leake", "Hanlon", "Quigley", "Wong", "Sweeting", "Mccrudden", "Alford", "Carrington", "Massey", "Burden", "Halford", "Worsnop", "Houlton", "Baines", "Lennox", "Petersen", "Donohoe", "Holdsworth", "Groom", "Bickley", "Osullivan", "Musgrove", "Avery", "Aziz", "Powers", "Thurston", "Felton", "Fagan", "Otoole", "Curley", "Gauntlett"
        };


        public static string[] Adresses = { "DE72 2BH", "KT4 7BQ", "GU11 1WT", "DD3 6DQ", "TN2 5PR", "NE63 9JR", "FK15 0HA", "BT42 1FX", "CM2 7NG", "NW1 1JY", "SP9 7TG", "G31 3RN", "GL5 4GA", "SA18 2GX", "B45 9RS", "LS16 5QS", "EC2M 6UR", "BS20 6PL", "PE11 3DX", "LS19 9GW", "GU11 3NY", "PE19 8PS", "MK10 9GZ", "BT35 9WE", "NG17 4HX", "SN10 5LL", "TW4 6ER", "IV30 9SB", "SA10 8PL", "BT1 9SG", "CW8 4AE", "SS16 5GH", "LE2 9HL", "PE28 3NZ", "DY2 7QX", "SM3 9JN", "NN5 4AZ", "DE14 3LD", "NW3 2HN", "EX32 0TF", "M14 4TH", "HR2 0RE", "NG5 6HH", "TQ4 7PT", "SS0 0EZ", "CA25 5PD", "NE61 2DW", "HD5 9PY", "WA15 7QR", "FY6 7SA", "E16 1FJ", "LA1 2LW", "PL6 5UG", "WA8 9DD",
            "BT37 0TQ", "SE1 6BF", "BA2 7NN", "S41 7JU", "RM12 5AD", "TW20 8BG", "WF17 1AG", "CR0 3DE", "RM3 0PD", "E14 5HZ", "PE19 2DD", "WS10 7DR", "ST10 1WA", "SG6 3RS", "CF45 3UT", "E14 0JT", "BT14 7GL", "RM12 4BB", "WN3 6BJ", "IV2 6XU", "CF23 6EQ", "DY11 7DX", "CA4 8JN", "DE55 5PT", "MK10 9TN", "KT19 9TG", "EX14 9NJ", "SE15 5QH", "BH2 6JG", "PE20 3EJ", "CW12 3QZ", "KY8 4EN", "SA4 3FN", "BT47 3RX", "BL9 8PF", "DE55 4JD", "NG34 0BF", "DN34 5UB", "N19 5NQ", "BS22 6BZ", "WR5 2RG", "EX36 4EY", "HS7 5PN", "BL5 3BY", "M24 1NA", "B7 5AR", "G66 8JG", "SP6 2PY", "DL6 2RX", "CB1 1BD", "SA67 8RS", "YO1 0JE", "SK9 3SN", "SE12 9HE", "EH14 7NN", "SY13 2AE", "EH32 0SH",
            "S63 9GN", "DD8 5HZ", "CM11 1DH", "PE27 6HN", "PO14 2DR", "SA19 8RH", "L23 7UL", "SE22 9DN", "SG13 8AP", "HU5 5DE", "NE41 8AD", "BS3 9HS", "DE12 6HE", "NP4 5FH", "FK15 9FE", "EX31 4EJ", "NN16 9QB", "CH45 4QD", "DL14 0LE", "AB21 0TB", "EH11 3TR", "NG17 8EJ", "KY12 0TR", "SP8 4NW", "SA5 7EQ", "PH1 4LY", "G42 7PP", "GL52 6ZU", "WF13 1RF", "DA2 7RS", "DN32 9FD", "PE7 1GN", "SW16 2BD", "GL52 5PX", "L27 6PY", "TF7 5RQ", "LA23 3FJ", "MK45 4SB", "BA21 3AS", "NG8 4BA", "RG7 1WJ", "CW8 3NW", "DN31 2BJ", "BD10 9QN", "BD4 7LJ", "NG17 7LH", "ME7 5AS", "EH55 8QS", "NP4 9RG", "PO1 9SJ", "CT50 1ZW", "SO31 5FG", "CV6 3DW", "KT16 9DE", "ST1 4LU", "PH2 9LA", "PO8 8AZ",
            "WS14 4HD", "YO15 2AH", "LA18 5AN", "SP5 2DL", "BT28 1QW", "W5 9HW", "CH7 5TF", "S5 7HE", "SS0 7TF", "EX2 8PQ", "TQ14 9QW", "G5 8BS", "BS30 9TE", "S75 3FE", "BA14 8JB", "AL5 5JJ", "LS10 2AD", "BT44 9RS", "LE19 4NL", "TA8 2LF", "WS12 1TH", "CO15 6EE", "OL4 5QU", "PR9 8JG", "TW13 7DG", "CB23 7DA", "CH7 1XZ", "SO41 0EP", "M22 1GN", "FY2 0NQ", "SP1 3GB", "GL1 3BS", "NE48 2SP", "NW10 5LP", "RG21 3JT", "BT49 0PQ", "RM14 3EP", "ST19 9EG", "ME2 4XH", "B71 2HD", "CV9 2BN", "BS31 3JJ", "G4 0NS", "ME16 8WW", "IP17 1WH", "SN5 6EG", "N1 8RP", "W1T 2RH", "GL20 7ES", "NN17 5DU", "M16 0BT", "LL56 4QJ", "E17 8AW", "CF34 9RB", "KY12 7QG", "SS14 2TL", "TD14 5RE", "ML4 2BX",
            "SY18 6DE", "ST5 0BW", "EX12 2RP", "LN13 0AB", "BT8 7YA", "BN18 9RQ", "LE16 9NT", "WR9 0LP", "B62 8NB", "HP21 8YU", "BB7 9YS", "PO22 9HJ", "ME14 5AA", "WR4 0HN", "FY3 8FL", "G15 6AN", "SN1 2AN", "SN9 5JJ", "BR6 9EA", "YO16 7BX", "M26 1FJ", "SP11 6LQ", "NR13 6BE", "CM23 2BZ", "M8 5SL", "DG8 9BD", "TN6 2TU", "EH53 0QB", "DN39 6FB", "DL7 7TH", "EC2A 4RQ", "CH66 2LD", "BS13 0JJ", "BH15 3TF", "TR2 5SE", "CF31 5FD", "LN6 5TE", "BT55 7EY", "KA16 9LG", "NG15 7SQ", "L40 6HB", "RG19 6HW", "KW16 3DQ", "GU34 2JS", "CM2 0LD", "DH9 0RE", "TS26 9JZ", "NN4 0RB", "NE4 9HJ", "BA14 0SW", "LS22 5BD", "OX29 4FJ", "CA14 2SB", "AB36 8UR", "EH4 4TG", "OX14 4PR", "EH8 7DB",
            "YO11 2BZ", "SA61 1JE", "LN5 0NW", "OX18 1EY", "NW5 9LE", "OX13 6DD", "WA6 7RG", "DT1 2AZ", "GU32 3AU", "E7 0JJ", "TW10 7JS", "B79 0LH", "N17 6HS", "S42 5DF", "DN36 4XU", "DL3 0JN", "ST3 5SS", "EN1 3QN", "EH9 2BU", "BH8 8LB", "PA3 2LY", "IP27 0HG", "B15 1UH", "E14 2DU", "TN25 5LL", "CO13 9JN", "TQ5 0AW", "RG26 3AW", "SS1 3NB", "NR28 9EY", "IV2 5PA", "HP3 9NW", "YO26 9TR", "NR7 9WA", "CB7 9FA", "IP14 2AT", "RH10 3ZF", "SL2 1AT", "SK8 5PZ", "NR23 1QB", "B65 0LU", "B62 9LN", "LN6 9BB", "IP33 2TG", "BT22 1GL", "EX39 4AU", "BA13 4TR", "AL4 9BZ", "BR8 8TP", "BL9 6NX", "SK10 1ND", "GU10 3EG", "RH10 1NY", "CM9 6DB", "EX11 1ET", "PE29 3PS", "RG22 5LZ", "CF3 3LZ",
            "BT12 6RH", "PE1 4PL", "EH42 1LX", "SS6 7TL", "CT1 2HP", "SS17 7SR", "CB8 8UR", "HR5 3AH", "ME1 9JB", "G76 0DA", "NG23 6QL", "ME2 2HZ", "CF24 4TT", "SN10 5AE", "M8 0TD", "KA11 5AT", "DE14 2AA", "DG12 5RP", "WN8 8BZ", "DD1 3JA", "B90 3GG", "LA22 9JH", "RH12 3RB", "M15 6PJ", "PL3 6NP", "DH5 0HP", "DN16 2QJ", "OX18 3XW", "NR6 7EX", "WF2 7ER", "PE25 1JN", "HU15 1JD", "TS15 0ER", "CT9 2HP", "IV31 6DT", "IP1 5DJ", "SE19 3HS", "NR6 5HW", "TN13 9SA", "SN12 8AQ", "SE1 3DQ", "AB54 6EB", "PO21 5QH", "UB4 0AZ", "CO13 0AA", "BS21 6BL", "B33 0SS", "CH1 6HL", "CO4 5JX", "SK8 3GW", "LL12 7HN", "GU51 3DG", "BD8 9QT", "HU18 1JG", "PR3 3UG", "TS24 8EJ", "G32 7LH", "W13 0EJ",
            "B70 8HL", "FK2 8HA", "BR2 9RW", "BB2 4AZ", "M7 4NR", "BN8 6AN", "BT81 7PD", "EN4 8SW", "OX14 4EJ", "SA4 8AB", "HR4 7NL", "LE18 4YS", "OX3 8PZ", "WF7 7LP", "BS8 3BB", "WD3 0GF", "TD14 5RS", "CH42 8QD", "ML7 5QW", "AB56 1TQ", "SW4 0PU", "NG11 6FR", "N10 2LY", "CV3 3BN", "BN14 9PW", "CW1 3JN", "TF4 3PP", "BS1 2NH", "SL4 5NQ", "AL10 0SG", "TQ1 3QT", "MK2 3QS", "RG42 5PY", "BT94 5GS", "EN9 1LF", "CM8 1RD", "WN3 4NF", "PR5 5SG", "PO5 4NB", "SO15 4HR", "SO19 6DR", "G22 7EY", "CO2 9EB", "L4 1UH", "B69 1LP", "L13 7EY", "OX3 8RA", "GU34 5NB", "CM6 1JJ", "CT12 6HY", "UB3 4QW", "YO12 6RN", "BB1 6PQ", "TR18 4TA", "BS36 2EE", "G66 2DH", "BT8 8LL", "DY2 7HG", "B79 7QA",
            "IP31 1BT", "TR17 0AA", "EN77 1AE", "S7 1FD", "BA21 5NS", "B6 6AX", "E4 7RG", "BT93 6EL", "OX29 8RX", "TN3 9BP", "CV7 7DR", "B45 8QD", "N11 2SR", "SS2 5AR", "CM15 9LL", "BS34 6NP", "RH8 9JA", "L37 8DQ", "WS3 2DD", "CT21 4LE", "PE9 3UF", "SR7 9RY", "PR4 1FD", "PH12 8TJ", "BT47 3FQ", "SS1 3LJ", "LA6 3BY", "WA16 7PX", "S62 7SQ", "ME9 9AT", "LA12 9HP", "LE19 2BW", "EX32 7SB", "HR6 9PQ", "RG12 9PW", "IP23 8NH", "PO19 1NU", "IM2 3QH", "EX16 5PJ", "ME10 5JZ", "BH6 5PR", "NN12 8RT", "CH7 1EX", "BT56 8AY", "NP16 5SD", "S65 3NX", "NE23 6LF", "S40 3QD", "N1 0JW", "LS7 2HN", "NG18 5GY", "CV31 2LF", "E14 4PA", "BT25 1LX", "WR15 8RX", "M9 0GP", "E2 9EG", "IM1 5AL",
            "S12 4HJ", "NG7 2RL", "FY5 2BP", "LL46 2UB", "DN5 8QT", "LA9 5QJ", "W1U 4QN", "BT9 6FS", "B31 9FA", "CM19 5SL", "NR12 9JA", "AB15 7YS", "CA13 0BA", "DA16 2RR", "WA16 7SA", "SN11 9PP", "SR5 5UA", "YO8 4PX", "BT92 8ER", "PH7 3ES", "CR0 2LD", "DE15 9DY", "NG20 0LX", "HA1 3PF", "S12 2TD", "SE12 9AF", "SG8 0DT", "TS14 7LB", "AL10 8RJ", "SA61 2RP", "TA4 1LE", "CF24 5EA", "TF2 6RT", "SL8 5SY", "NW1 9YB", "GL14 3DZ", "AB11 5QF", "CF46 5NR", "WF4 2LZ", "BS40 9UT", "BH12 4AH", "N9 8BA", "M16 0JG", "NR1 3TD", "PO30 1YH", "IP19 0JU", "LL65 3HN", "NE61 1BZ", "NR20 4DA", "NR18 9AN", "BB8 7LX", "HU19 2DX", "KT6 7WN", "CM1 6FJ", "BT38 7XA", "CA14 2AZ", "BR7 5LR", "B92 9NX",
            "B12 8LZ", "GU14 9UT", "GU30 7PP", "E9 7NQ", "E17 7QF", "LN5 5PL", "PL21 9NP", "G12 8PS", "SN15 2EA", "TR1 3EG", "PO18 0PN", "OX28 1DG", "GU27 1JQ", "AB12 3RW", "CV6 5NH", "SE9 3NY", "KA1 2EH", "GU2 8AF", "M13 9PZ", "B67 6DB", "M15 4FB", "L21 9HG", "FY2 0XZ", "SE4 2LD", "RG18 9WW", "WF8 4DP", "OX1 4JU", "KA3 7BX", "WN2 1AZ", "GU12 4EP", "NW6 1XB", "AB16 5LY", "OL2 7XQ", "NE33 3JW", "BA13 4NX", "RH13 9XU", "E5 9DS", "BN17 5EW", "LE4 5PH", "HP4 1TH", "BS5 9TE", "G66 7JT", "WN3 5DD", "B68 0QB", "NR3 3PR", "BT62 2NG", "SE12 9PG", "BN22 9EH", "SN5 8BL", "LA1 1JL", "HP18 0XY", "CV37 8EG", "KA9 2BG", "BT74 4LT", "M14 6JH", "GY2 4GE", "ST5 6JW", "FY1 5NF", "EH21 7PL",
            "SL1 0XA", "G20 9EQ", "KA7 4PE", "N7 0QT", "AB21 9SS", "S71 1UJ", "SA14 9DP", "B2 4NU", "SG19 2AZ", "RG7 4GA", "PL20 6LQ", "TS10 1JR", "KT7 0SR", "WR13 5DW", "KA3 6JN", "B66 4BQ", "EX1 2TT", "DA1 4BZ", "DN2 4LA", "MK41 8LA", "N17 6AJ", "CW11 3BF", "WF7 5DU", "SO21 1RJ", "ST16 3DP", "OX7 4JN", "DH6 2TE", "DL7 9SE", "AL5 1PU", "CR8 2HY", "B90 4QL", "SK7 4PZ", "SM5 1SD", "BS4 3BG", "NR27 9PA", "IV27 4LL", "DT6 5AA", "PO30 5TD", "M45 7BY", "DY2 9JE", "IG1 8LT", "SN15 9XQ", "TA12 6EP", "HA9 8EG", "SA64 0JT", "EN11 0FA", "DN7 4LZ", "BT92 6GD", "GL11 4JP", "SR5 4BH", "NP18 3TG", "WR4 0DH", "G20 9TR", "L11 8LB", "TQ12 2LR", "AB56 1DZ", "EX38 8QR", "PO2 9PS", "AL5 3HB",
            "EH5 3HB", "DN7 6NY", "SM2 5NQ", "WN2 2QY", "PE4 6GW", "TN5 6PL", "EN2 7HR", "BA2 2JD", "CB1 9HT", "DA9 9XX", "AL9 6DQ", "CV12 0LD", "SN12 8AW", "IP27 9HF", "RG8 9QN", "NR12 0AS", "WD6 1PA", "ME16 0GN", "ST20 0BT", "SE11 9AS", "KT12 1HH", "BS23 4TJ", "RG40 4LL", "PE14 9DU", "KA18 3DF", "CT17 9BA", "M61 0RU", "E7 0HL", "RH18 5JG", "BN9 9EU", "NR29 4AQ", "WD6 3ET", "AL9 7RW", "SP6 1AU", "SE3 0EZ", "SS5 4DX", "G11 6AA", "BS35 4BY", "DY11 6TL", "CM21 0LA", "SN2 1RF", "PR2 1EH", "DG3 4BP", "WS11 5UE", "B12 9QX", "M11 3ND", "NW2 6UL", "M6 5JG", "ST9 0DX", "EX39 4JY", "AB30 1SA", "DN15 9QY", "SO19 2DZ", "CM3 5YG", "KY3 0AX", "HA1 1XU", "SR7 0JS", "YO61 2NS", "BN10 7HR",
            "DE21 4EA", "WF7 5AS", "CV23 0BW", "B68 0ED", "CF14 0PF", "CM3 3NH", "MK40 4JN", "S35 9WA", "EH47 9ED", "EN3 5HD", "TA4 4SS", "HU12 0DS", "CV10 7PR", "CF23 9DU", "FK7 9DG", "BR2 9LN", "DA7 6ND", "BB12 8LE", "WF4 3EP", "DD3 0JB", "YO32 5PG", "CO12 3SE", "BD13 2JA", "WA13 0AA", "SK8 3DY", "NG16 2NL", "KT2 7HS", "MK9 3DA", "FK10 3BX", "GU33 6ET", "CO7 9BW", "IG1 1EN", "KT22 9PB", "CF64 4HR", "BN41 1LT", "BT62 2BW", "NR11 8DS", "EH21 6DZ", "EH17 8DX", "RG1 2RF", "IP13 8NB", "LA9 6NF", "SW19 7QY", "IG9 5PJ", "HU17 7HD", "CF31 2HQ", "DE21 4ER", "BT41 2TH", "OX11 6AB", "S81 0PT", "EN1 2LR", "NN14 2FH", "BL4 8JG", "M14 6XY", "DN21 2SE", "PO19 7PS", "FK8 1JX", "NE28 8TP",
            "N7 8LS", "N17 8NS", "BS10 5LJ", "WA16 8XJ", "SA17 5UU", "HA4 8NF", "CH3 8JA", "B62 9PJ", "NE15 7JU", "LS10 3XJ", "TS12 1ND", "DN6 7RY", "G42 7ER", "EN9 1RG", "B36 9HY", "SY3 9EJ", "BT48 6TW", "M28 8DG", "E14 6NH", "BR2 0QE", "HP8 4BW", "BB18 5SB", "M46 9DL", "TN13 1EQ", "BN15 9UQ", "SW7 9AY", "GL2 4TX", "FK6 5PH", "SL4 4SJ", "EH4 8AJ", "CO7 0AL", "OX11 9BP", "WS12 1JA", "LE12 5SJ", "LN3 5BD", "IP31 1AN", "B31 3BG", "TR13 8RQ", "LE11 2UR", "DN16 2QD", "BS6 7YJ", "IV12 5LE", "TW11 9AT", "NR31 7DZ", "BD7 3DL", "EX20 2AE", "BS24 8ET", "LE17 5RT", "BB5 0JE", "MK13 0AD", "ST5 6QW", "YO25 5AQ", "AL3 4SL", "SE16 4PB", "WS13 6GQ", "LL77 7UH", "GL15 4BA", "BH23 1JB", "BA22 7ND",
            "HD4 7HS", "NG17 2SF", "SW18 3PT", "S10 1UD", "CH62 5BS", "WF14 0PY", "TN6 2HW", "NR11 6AE", "PR7 1ER", "BA12 8NF", "AB10 7EY", "LL54 7HU", "BH21 1TG", "BT43 6TG", "IP12 4SF", "PL7 1HS", "SE3 8QN", "UB5 4AA", "SE5 9QN", "M17 1BJ", "WS1 9QW", "BT63 5RY", "BS23 3JJ", "N4 1ER", "CV7 7DA", "SA2 0NB", "CF34 9UB", "SG12 8RT", "SO52 9FD", "NG16 2WT", "SP3 5PQ", "MK43 7HW", "SO14 7EJ", "NG34 0HN", "CT13 0LH", "TQ9 5SB", "DD4 9DY", "W1B 1DY", "BT23 8WJ", "NR13 3RP", "GL2 0XP", "CB11 4PJ", "SY1 4TZ", "DD10 9HF", "EX31 1NX", "PL1 3QG", "L34 6JD", "ZE1 0NW", "EX34 9HJ", "RG8 7DY", "CT5 1NT", "CH3 6AL", "LN6 3LS", "SP4 8ED", "CF35 5LD", "IP25 6NZ", "B43 6HE", "OL3 6ET", "TD15 2HT",
            "CW4 7BD", "SK9 6NA", "TS11 6HH", "BS16 6SX", "L4 8RY", "CM22 7NX", "DE56 2TG", "TW19 7RX", "KA10 6BT", "DT11 7TL", "TQ4 6PE", "ST3 1NH", "B49 6AY", "KY6 1AQ", "YO32 2QR", "BS10 6HJ", "YO19 6EF", "SO16 9LS", "SA73 3BY", "BB18 6LQ", "PE11 4LB", "BT27 6TX", "BL1 7JU", "HR3 5PF", "NG20 9EN", "FY8 4EL", "G14 0SZ", "BT34 2JS", "L11 4TY", "MK6 1NE", "EX39 3ET", "IP25 7JL", "WD17 1QE", "N1 0UD", "WA7 2UH", "SN38 1JR", "MK2 2NZ", "IV2 5BD", "RH13 6PE", "CH63 2JQ", "CR0 6BA", "B45 9AU", "OL16 1QZ", "DN17 3HQ", "LN6 8EB", "SO14 2DZ", "W1U 2NY", "BT19 6SF", "HD6 1QU", "SW1P 1JU", "HG5 0UD", "HP11 9SU", "GL1 1SX", "S70 1HS", "CO10 8BZ", "OL12 6BX", "WV4 6DP", "WF8 1SA", "S44 6BH",
            "OX11 7EY", "NN3 9AL", "RH17 7PS", "TF9 1JL", "ML6 0ER", "EH48 4BY", "TN27 8LS", "NP26 4PQ", "WF4 2LA", "SN6 8NT", "ST5 9PQ", "EX13 5UE", "LA8 8JL" };

        private static Random Rnd;
        private static char[] LettersArr = { 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z' };
        private static char[] ULettersArr = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' };

        public void SetRandomSeed(Random randSeed)
        {
            Rnd = randSeed;
        }

        public static string GetRandomForename(string source)
        {
            return Forenames[Rnd.Next(0, Forenames.GetUpperBound(0))];
        }

        public static string GetRandomSurname(string source)
        {
            return Surnames[Rnd.Next(0, Surnames.GetUpperBound(0))];
        }

        public static string GetRandomPostCode()
        {
            return Adresses[Rnd.Next(0, Adresses.GetUpperBound(0))];
        }
        private static long LongRandom(long min, long max)
        {
            byte[] buf = new byte[8];
            Rnd.NextBytes(buf);
            long longRand = BitConverter.ToInt64(buf, 0);

            return (Math.Abs(longRand % (max - min)) + min);
        }

        public static string GetRandomNumberString(long lowerBound, long upperBound)
        {
            string returnString = "";
            try
            {
                returnString = LongRandom(lowerBound, upperBound).ToString();

            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message + e.InnerException);
            }

            return returnString;

        }

        public DateTime RandomDate()
        {
            DateTime start = new DateTime(1955, 1, 1);
            int range = (DateTime.Today - start).Days;
            DateTime returnDate = DateTime.MaxValue;
            try
            {
                returnDate = start.AddDays(Rnd.Next(range));
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message + e.InnerException);
            }
            return returnDate;
        }

        public string RandomiseText(string sourceText)
        {
            if (string.IsNullOrEmpty(sourceText))
            {
                return null;
            }
            StringBuilder returnString = new StringBuilder();
            foreach (var character in sourceText)
            {
                if (char.IsLetter(character))
                {
                    returnString.Append((char.IsUpper(character) ? ULettersArr[Rnd.Next(0, 25)] : LettersArr[Rnd.Next(0, 25)]));
                }
                else if (char.IsDigit(character))
                {
                    returnString.Append(RandomNumber());
                }
                else
                {
                    returnString.Append(character.ToString());
                }
            }
            return returnString.ToString();
        }

        public decimal RandomiseDecimal(decimal sourceDecimal)
        {
            return sourceDecimal * Convert.ToDecimal(0.5 + Rnd.NextDouble());
        }

        public int RandomNumber()
        {
            return Rnd.Next(1, 9);

        }

        public string RandomMobile()
        {
            return "07" + RandomNumber() + RandomNumber() + RandomNumber() +
                        RandomNumber() + RandomNumber() + RandomNumber() +
                        RandomNumber() + RandomNumber();
        }

        public string RandomPhoneNumber()
        {
            StringBuilder telNo = new StringBuilder(12);
            int number;

            telNo = telNo.Append("0");
            for (int i = 0; i < 4; i++)
            {
                number = Rnd.Next(0, 8);
                telNo = telNo.Append(number.ToString());
            }
            telNo = telNo.Append(" ");
            number = Rnd.Next(0, 743);
            telNo = telNo.Append(String.Format("{0:D3}", number));
            number = Rnd.Next(0, 10000);
            telNo = telNo.Append(String.Format("{0:D4}", number));
            return telNo.ToString();
        }

        public T RandomEnumValue<T>()
        {
            var v = Enum.GetValues(typeof(T));
            return (T)v.GetValue(Rnd.Next(v.Length));
        }
    }
}
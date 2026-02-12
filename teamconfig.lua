local TeamConfig = {}

TeamConfig.SiteName = "SITE-83"

TeamConfig.System = {
	XPGain = 85,              
	Interval = 300,           
	XP_DataStore = "XP_V1.0", 
	WL_AdminID = {814033297, 7134662083, 1292329440, 4925325, 3462316927, 8088074020, 5701151731, 4962570650, 2026380988, 1562868739, 1111996530} 
}

TeamConfig.Colors = {
	WL = Color3.fromRGB(255, 50, 50),
	XP = Color3.fromRGB(0, 170, 255),
	Open = Color3.fromRGB(0, 255, 100)
}

TeamConfig.Teams = {
	{Name = "Classe-D", XP = 0, WL = false, Category = "COMMENCEMENT"},
	{Name = "Spawn", XP = 0, WL = false, Category = "COMMENCEMENT"},

	{Name = "Direction DIST", XP = 0, WL = true, Category = "DI&ST"},
	{Name = "Chef de Secteur", XP = 15000, WL = false, Category = "DI&ST"},
	{Name = "Chef Adjoint de Secteur", XP = 12000, WL = false, Category = "DI&ST"},
	{Name = "Superviseur de Maintenance", XP = 5000, WL = false, Category = "DI&ST"},
	{Name = "Technicien de Surface", XP = 800, WL = false, Category = "DI&ST"},
	{Name = "Agent d'Entretien", XP = 300, WL = false, Category = "DI&ST"},

	{Name = "Direction Scientifique", XP = 0, WL = true, Category = "DÉPARTEMENT SCIENTIFIQUE"},
	{Name = "Superviseur", XP = 0, WL = true, Category = "DÉPARTEMENT SCIENTIFIQUE"},
	{Name = "Chercheur Exprimentés", XP = 5000, WL = false, Category = "DÉPARTEMENT SCIENTIFIQUE"},
	{Name = "Chercheur Débutant", XP = 1200, WL = false, Category = "DÉPARTEMENT SCIENTIFIQUE"},
	{Name = "Assistant Chercheur", XP = 200, WL = false, Category = "DÉPARTEMENT SCIENTIFIQUE"},

	{Name = "O.F.I.M", XP = 0, WL = true, Category = "FORCES d'INTERVENTION"},
	{Name = "O.1", XP = 0, WL = true, Category = "FORCES d'INTERVENTION"},
	{Name = "A1", XP = 0, WL = true, Category = "FORCES d'INTERVENTION"},
	{Name = "Bêta-1", XP = 0, WL = true, Category = "FORCES d'INTERVENTION"},

	{Name = "Direction Sécuritaire", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
	{Name = "Marshal", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
	{Name = "Chef Carcéral", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
	{Name = "P.I", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
	{Name = "Anti Emeute", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
	{Name = "Escouade Zulu", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
	{Name = "Capitaine U.I.T", XP = 25000, WL = false, Category = "SÉCURITÉ DU SITE"},
	{Name = "Sergent U.I.T", XP = 12000, WL = false, Category = "SÉCURITÉ DU SITE"},
	{Name = "Caporal U.I.T", XP = 8000, WL = false, Category = "SÉCURITÉ DU SITE"},
	{Name = "U.I.T", XP = 3600, WL = false, Category = "SÉCURITÉ DU SITE"},
	{Name = "Agent Carcéral", XP = 1200, WL = false, Category = "SÉCURITÉ DU SITE"},
	{Name = "Recrue Carcéral", XP = 200, WL = false, Category = "SÉCURITÉ DU SITE"},

	{Name = "Direction Médical", XP = 0, WL = true, Category = "DÉPARTEMENT MÉDICAL"},
	{Name = "Médecin Chef", XP = 6000, WL = false, Category = "DÉPARTEMENT MÉDICAL"},
	{Name = "Médecin de Terrain", XP = 4500, WL = false, Category = "DÉPARTEMENT MÉDICAL"},
	{Name = "Médecin", XP = 1000, WL = false, Category = "DÉPARTEMENT MÉDICAL"},

	{Name = "Comité d'Ethique", XP = 0, WL = true, Category = "CONFORMITÉ & JUSTICE"},
	{Name = "Justice Internes", XP = 0, WL = true, Category = "CONFORMITÉ & JUSTICE"},
	{Name = "BRF", XP = 0, WL = true, Category = "CONFORMITÉ & JUSTICE"},

	{Name = "Direction de l'Installation", XP = 0, WL = true, Category = "ADMINISTRATION"},
	{Name = "Ressources Humaines", XP = 0, WL = true, Category = "ADMINISTRATION"},
	{Name = "Conseiller Administratif", XP = 12000, WL = false, Category = "ADMINISTRATION"},
	{Name = "Secrétaire", XP = 5000, WL = false, Category = "ADMINISTRATION"},

	{Name = "Haut Commandement", XP = 0, WL = true, Category = "HAUT COMMANDEMENT"},
	{Name = "Confidentiel A", XP = 0, WL = true, Category = "HAUT COMMANDEMENT"},
	{Name = "Confidentiel B", XP = 0, WL = true, Category = "HAUT COMMANDEMENT"},

	{Name = "Insurrection Du Chaos", XP = 0, WL = true, Category = "GROUPES D'INTÉRÊT"},
	{Name = "Détachement Bravo", XP = 0, WL = true, Category = "SÉCURITÉ DU SITE"},
}

TeamConfig.Order = {
	"HAUT COMMANDEMENT", "ADMINISTRATION", "CONFORMITÉ & JUSTICE", "FORCES d'INTERVENTION",
	"SÉCURITÉ DU SITE", "DÉPARTEMENT SCIENTIFIQUE", "DI&ST", "DÉPARTEMENT MÉDICAL",
	"COMMENCEMENT", "GROUPES D'INTÉRÊT"
}

return TeamConfig

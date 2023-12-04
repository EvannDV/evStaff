Config = {}
evCheckStaff = {}
evNotifR = {}
evCore = {}


Config.UrServ = "SideDev"


-- > Système rélaisé par: moi :)

evCheckStaff = {   --> Ajouter ici les groupes qui auront accès au menu Staff
    {name = "admin"},   
    {name = "superadmin"},   
    {name = "owner"}, 
}

evNotifR = {"admin","superadmin","owner"}  --> Ajoutez ici les groupes qui auront accès au notifications des reports


evCore = {
    IsEnabledStaffClothes = true,  --> true/false Pour avoir ou non la tenue staff à la prise de service
}


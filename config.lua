Config = {}

Config.Mysql = 'oxmysql'
Config.Framework = 'esx'

Config.UpdateStoredOnStart = true

Config.HelpNotify = 'Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage.'
Config.Notifications = {
  notowner   = { message = 'Ce véhicule ne vous appartient pas.', type = 'error' },
  notvehicle = { message = 'Pas de véhicule dans ce garage.',     type = 'error' },
}

-- Points de garage
Config.GarageCoords = {
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(213.59, -809.34, 31.01),  npcHeading=0.0,    parking=vector3(215.68, -792.62, 29.83), parkout=vector3(222.45, -801.44, 30.25), vehicleHeading=246.89, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(-899.275,-153.0,41.88),   npcHeading=121.86, parking=vector3(-906.28,-154.96,41.06), parkout=vector3(-911.93,-164.65,41.45), vehicleHeading=27.11,  garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(275.182,-345.534,45.173), npcHeading=0.0,    parking=vector3(272.68,-337.14,44.0),    parkout=vector3(285.34,-335.65,44.49),  vehicleHeading=250.6,  garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(-833.255,-2351.34,14.57), npcHeading=284.43, parking=vector3(-826.95,-2351.44,13.6), parkout=vector3(-820.66,-2361.0,14.15),  vehicleHeading=329.02, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(-2162.82,-377.15,13.28),  npcHeading=165.99, parking=vector3(-2165.56,-383.22,12.19),parkout=vector3(-2169.86,-373.34,12.67), vehicleHeading=169.68, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(-423.85,1206.11,325.76),  npcHeading=260.8,  parking=vector3(-418.73,1206.37,324.80),parkout=vector3(-422.07,1198.1,352.22),  vehicleHeading=229.16, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(112.23,6619.66,31.82),    npcHeading=237.14, parking=vector3(116.99,6613.56,31.0),   parkout=vector3(111.88,6602.95,31.51),  vehicleHeading=272.66, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(1951.79,3750.95,32.16),   npcHeading=118.06, parking=vector3(1948.04,3747.62,31.22), parkout=vector3(1950.16,3759.21,31.78),  vehicleHeading=30.35,  garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(1851.43,2587.75,45.67),   npcHeading=251.45, parking=vector3(1856.02,2589.47,44.80), parkout=vector3(1854.8,2579.11,45.25),   vehicleHeading=272.67, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(916.81,-15.27,78.76),     npcHeading=146.82, parking=vector3(913.89,-19.08,77.94),   parkout=vector3(907.01,-13.41,78.34),   vehicleHeading=147.92, garageName='Garage'},
  {garageType='normal', npcHash='csb_prolsec', npc=vector3(99.79,-1072.98,29.37),    npcHeading=250.0,  parking=vector3(107.32,-1070.57,28.37), parkout=vector3(117.64,-1082.05,28.77), vehicleHeading=3.1,    garageName='Garage'},
  {garageType='impound', npcHash='csb_prolsec', npc=vector3(-181.24,-1282.1,31.2959),npcHeading=192.07, parking=vector3(-181.81,-1287.4,25.271),parkout=vector3(-189.10,-1290.3,30.871), vehicleHeading=269.66, garageName='Fourrière'},
}

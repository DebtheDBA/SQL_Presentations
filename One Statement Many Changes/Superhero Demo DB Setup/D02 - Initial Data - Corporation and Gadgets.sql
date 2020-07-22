USE Superheroes;
GO

IF NOT EXISTS (SELECT * FROM Corporation)
INSERT INTO Corporation (Corporation_Name)
VALUES ('Stark Industries'), ('Wayne Enterprises');

IF NOT EXISTS (SELECT * FROM Gadget)
INSERT INTO Gadget ([Gadget_Name], [Gadget_Desc])
VALUES ('Lasso of Truth', 'Forces the person trapped in it to tell the truth'),
('Magical Bracelets', 'Deflect any projectile'),
('Royal Tiara', 'Defensive and offensive Projectile'),
('Invisible Jet', 'Transportation')
;


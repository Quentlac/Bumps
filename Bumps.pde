class Boule{
  float x = 0;
  float y = 50;
  
  float forceVertical = 0; 
}

class Anneau{
  float x = 400;
  float y = 50;
  
  float active = 0;

}

Anneau tableauAnneaux[] = new Anneau[10];

Boule boule = new Boule();

float gravity;

float tableauDessin[] = new float[80];

float curseurDessin = 10;

float vitesse = 10;

int gameOver = 0;

int score = 0;

PImage replayBouton;
PImage pauseBouton;
PImage playBouton;
PImage tutoBouton;
PImage perso;
PImage titre;

int pause = 0;
int intro = 1;

void setup(){
  smooth();
  
  fullScreen();  
  orientation(LANDSCAPE);
  
  //size(600,300);
  boule.x = 0.5*width;
  
  for(int i = 0; i < 80;i++){
    tableauDessin[i] = height/2;     
    
  }
  
  for(int i = 0; i < 10;i++){
    tableauAnneaux[i] = new Anneau();
    
    tableauAnneaux[i].x = width + (i+1)*(width*1.5);
    tableauAnneaux[i].y = int(random(60,height-60));
  }
  
  vitesse = 0.0125*width;
  gravity = 0.0005 * height;
  
  replayBouton = loadImage("replay.png");
  pauseBouton = loadImage("pause.png");
  playBouton = loadImage("play.jpg");  
  tutoBouton = loadImage("tuto.png"); 
  perso = loadImage("perso.png"); 
  titre = loadImage("titre.png"); 
}

void draw(){
  background(255);
  
  strokeWeight(1);
  line(0,height/2,width,height/2);
  
  afficheBoule();
  
  
  afficheAnneau();
  afficheLigne();
  
  if(gameOver == 0){
    if(intro == 0){
      afficheUI();
    
      if(pause == 0){
              
        moveBoule();
        dessinLigne();
        moveAnneau();
      }
      else{
        //pause 
      }
    }
    else{
      afficheMenuIntro();  
      
    }
  }
  else{
    afficheGameOver();   
  }
}

void afficheBoule(){
  strokeWeight(1);
  
  fill(255,0,0);
  
  //ellipse(boule.x,boule.y,0.08*height,0.08*height);
  image(perso,boule.x-(0.1*height)/2,boule.y-(0.1*height)/2,0.1*height,0.1*height);
  
  
}

void moveBoule(){
  boule.y += boule.forceVertical;
  
  //               longueur vertic d'un trait
  int posX = int(boule.x / (0.625*width/50));
  
  float hauteurDessin = tableauDessin[posX-1] + ((tableauDessin[posX] - tableauDessin[posX-1])*curseurDessin/(0.625*width/50));
  
    
  if(boule.y + 0.04*height > hauteurDessin){
    if(boule.forceVertical > 0)boule.forceVertical = 0;
    boule.forceVertical -= gravity*(0.0023*height);
  }
  else{
    boule.forceVertical += gravity;  
  }
  println(hauteurDessin);
}

void afficheAnneau(){
  
  noFill();
  strokeWeight(0.01*height);
  
  for(int i = 0; i < 10;i++){
    if(tableauAnneaux[i].active == 0)stroke(255,200,0); 
    if(tableauAnneaux[i].active == 1)stroke(255,50,0);
    
    ellipse(tableauAnneaux[i].x,tableauAnneaux[i].y,width*0.05,height*0.18);
  }
  stroke(0);
}

void moveAnneau(){
  for(int i = 0; i < 10;i++){
    tableauAnneaux[i].x -= vitesse/2;  
    if(tableauAnneaux[i].x < 0){
      
      if(tableauAnneaux[i].active == 0){
        gameOver = 1;  
      }
      
      float maxX = 0;
      for(int j = 0; j < 10;j++){
        if(tableauAnneaux[j].x > maxX){
          maxX = tableauAnneaux[j].x;
        }
      }
      
      tableauAnneaux[i].x = maxX + int(random(width,width+500));  
      tableauAnneaux[i].y = int(random(60,height-60));
      tableauAnneaux[i].active = 0;
    }
    else if(tableauAnneaux[i].x < boule.x + 0.04*height && tableauAnneaux[i].x > boule.x - 0.04*height && tableauAnneaux[i].active == 0){
      if(boule.y > tableauAnneaux[i].y -0.08*height && boule.y < tableauAnneaux[i].y + 0.08*height){
        tableauAnneaux[i].active = 1;  
        score += 10;
      }
    }
    
  }
  score++;
  println(score);
  
}

void dessinLigne(){
 
  if(mouseY > height/2){
    tableauDessin[49] = mouseY;
  }
  else{
    tableauDessin[49] = height/2;  
  }
  
  if(curseurDessin > 0)curseurDessin -= vitesse;
  else{
    //on decale tout dans le tableau
    curseurDessin = (0.625*width/50);
    
    for(int i = 0; i < 49 ;i++){
      tableauDessin[i] = tableauDessin[i+1];    
    }
    
  }  
  
}

void afficheLigne(){
  fill(0);
  strokeWeight(5);
  
  for(int i = 0; i < 50;i++){
    //ellipse(i*10+curseurDessin,tableauDessin[i],30,30); 
    if(i > 0){
      line(i*(0.625*width/50)+curseurDessin-(0.625*width/50),tableauDessin[i-1],i*(0.625*width/50)+curseurDessin,tableauDessin[i]);
    }
  }  
  
}

void afficheUI(){
  if(pause == 0){
    image(pauseBouton,0.025*height,0.025*height,width/16,width/16);
  }
  else{
    image(playBouton,0.025*height,0.025*height,width/16,width/16);  
  }
  image(replayBouton,width - (0.025*height)-width/21,0.025*height,width/21,width/21);
  
  
  textAlign(CENTER);
  textSize(0.0350*width);
  text(str(score),width/2,0.06*height);
  
  if(score < 200){
    tint(255,255,255,100);
    image(tutoBouton,width/15,height-(0.045*height)-width/7,width/7,width/7);  
    tint(255,255,255,255);
  }
  
  if(mousePressed == true){
    
    //bouton pause
    if(mouseX < (0.025*height+width/16) && mouseY < (0.025*height+width/16)){
      delay(100);
      if(pause == 0)pause = 1;
      else pause = 0; 
    }
    
    //bouton replay
    if(mouseX > (width - (0.025*height)-width/22) && mouseY < (0.025*height+width/16)){
      delay(1000);
      recommencer(); 
    }
    
  }
  
}

void recommencer(){
  for(int i = 0; i < 80;i++){
    tableauDessin[i] = height/2;     
    
  }  
  for(int i = 0; i < 10;i++){    
    tableauAnneaux[i].x = width + (i+1)*(width*1.5);
    tableauAnneaux[i].y = int(random(60,height-60));
    tableauAnneaux[i].active = 0;
  }
  boule.forceVertical = 0;
  gameOver = 0;
  boule.y = 50;
  score = 0;  
  
  
}

void afficheGameOver(){
  textSize(0.0625*width);
  textAlign(CENTER);
  text("Tu as perdu!",width/2,0.15*height);
  textSize(0.0400*width);
  text("Score: "+str(score),width/2,0.25*height);
    
  image(replayBouton,(width/2)-(height/6)/2,height/3.4,height/6.3,height/6.3);
    
  if(mouseX > ((width/2)-(height/6)/2) && mouseX < ((width/2)-(height/6)/2)+height/6.3 && mouseY > height/3.4 && mouseY < (height/3.4)+height/6.3){
    recommencer();
  }  
  
}

void afficheMenuIntro(){
  
  image(titre,width/2-(width/1.5)/2,0,width/1.5,height/3);  
  image(playBouton,width/2-(height/3)/2,height/2-(height/3)/2,height/3,height/3);  
  
  if(mousePressed == true){
    if(mouseX > width/2-(height/3)/2 && mouseX < (width/2-(height/3)/2)+height/3 && mouseY > height/2-(height/3)/2 && mouseY < (height/2-(height/3)/2)+height/3){
      
      intro = 0;  
    }
    
  }
  
}

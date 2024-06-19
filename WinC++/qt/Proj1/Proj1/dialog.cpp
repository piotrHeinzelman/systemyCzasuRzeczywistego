#include "dialog.h"
#include "./ui_dialog.h"

Dialog::Dialog(QWidget *parent)
    : QDialog(parent)
    , ui(new Ui::Dialog)
{
    ui->setupUi(this);
    this->pushButton = ui->pushButton;
    this->textline1 = ui->lineEdit;
    this->textline2 = ui->lineEdit_2;

    this->textCRC = ui->label_3;
    this->textCycle = ui->label_6;
    this->textTime = ui->label_8;



}

Dialog::~Dialog()
{
    delete ui;
}



void Dialog::on_pushButton_released()
{
    QString data = textline1->text();
    QString cycleNumString = textline2->text();
    int CRC=0;
    QByteArray CRCstr="0x0000";
    bool ok;
    long cycleNum = cycleNumString.toLong( &ok, 10);
    if (cycleNum==NULL || cycleNum<0) { cycleNum=1; }
    long tmp;
    int a=0;
    int b=0;
    this->textCRC->setText( data );
    this->textCycle->setText( QLocale().toString( cycleNum ) );


    this->pushButton->setText("...");
    QElapsedTimer timer;
    timer.start();

    tmp=cycleNum;
    while( tmp-- ){
        //int CRC = assembly();
        CRC=calculateCRC( &data, cycleNum );
        //for (int i=0;i<99;i++){ int j=0;j++;j++;j=j+j/j+j/j; }
        //this->textCRC->setText( QLocale().toString( cycleNum ) );
    }
     b=CRC;

     a=b%16;
     b=(b-a)/16;
     if (b<0){b=0;}
     if (a>9){a=a+7;}
     if (a<0){a=0;}
     CRCstr[5]=char(48+a);

     a=b%16;
     b=(b-a)/16;
     if (b<0){b=0;}
     if (a>9){a=a+7;}
     if (a<0){a=0;}
     CRCstr[4]=char(48+a);

     a=b%16;
     b=(b-a)/16;
     if (b<0){b=0;}
     if (a>9){a=a+7;}
     if (a<0){a=0;}
     CRCstr[3]=char(48+a);

     a=b%16;

     if (a>9){a=a+7;}
     if (a<0){a=0;}
     CRCstr[2]=char(48+a);


    this->textCRC->setText( CRCstr);
    this->textTime->setText(  QLocale().toString(timer.elapsed()) + " [ms]" ) ;
    this->textCycle->setText(  QLocale().toString(timer.elapsed()/(1.0*cycleNum)) + " [ms]" ) ;
    this->pushButton->setText("Start");

// http://www.ibiblio.org/gferg/ldp/GCC-Inline-Assembly-HOWTO.html

    /*

 QString str = "FF";
 bool ok;

 long hex = str.toLong(&ok, 16);     // hex == 255, ok == true
 long dec = str.toLong(&ok, 10);

     */


}

long Dialog:: calculateCRC( QString* data, long cyclesNum ){
    // https://www.codeproject.com/Articles/15971/Using-Inline-Assembly-in-C-C

    long num=cyclesNum;
    int  val ;
    asm ("movl %0, %%eax;"
         "movl %1, %%ebx;"
         "add  %%ebx, %%eax;"
         "movl %%ebx , %0;"
        : "=r" ( val )        /* output */
        : "r" ( data, num )         /* input */
        : "%ebx"         /* clobbered register */
        );

    return val;
}

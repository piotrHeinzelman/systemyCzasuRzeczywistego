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
    long cycleNum = (long) cycleNumString;
    this->textCRC->setText( data );
    this->textCycle->setText( cycleNum );


}


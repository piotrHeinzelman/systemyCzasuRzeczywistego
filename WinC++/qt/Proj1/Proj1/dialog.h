#ifndef DIALOG_H
#define DIALOG_H

#include <QDialog>
#include <QLabel>
#include <QLineEdit>


QT_BEGIN_NAMESPACE
namespace Ui {
class Dialog;
}
QT_END_NAMESPACE

class Dialog : public QDialog
{
    Q_OBJECT

public:
    Dialog(QWidget *parent = nullptr);
    ~Dialog();
    long calculateCRC( QString *data, long cyclesNum );

private slots:
    void on_pushButton_released();

private:
    Ui::Dialog *ui;
    QPushButton *pushButton ;
    QLabel      *textCRC;
    QLabel      *textCycle;
    QLabel      *textTime;
    QLineEdit   *textline1;
    QLineEdit   *textline2;
    QString     *data;
    long         cycleNum;
};
#endif // DIALOG_H

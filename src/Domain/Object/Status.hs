module Domain.Object.Status where

import Essential

data Status
  = AC
  | WJ
  | WR
  | CE
  | MLE
  | TLE
  | RE
  | OLE
  | IE
  | WA

instance Show Status where
  show AC = "AC (Accepted)正答です。運営が用意したテストを全てパスし、正しいプログラムであると判定されました。"
  show WJ = "WJ (Waiting for Judging) 提出したプログラムはジャッジを待っている状態です。"
  show WR = "WR (Waiting for Re-judging) 再ジャッジを待っている状態です。"
  show CE = "CE (Compilation Error) 提出されたプログラムのコンパイルに失敗しました。"
  show MLE = "MLE (Memory Limit Exceeded) 問題で指定されたメモリ制限を超えています。"
  show TLE = "TLE (Time Limit Exceeded) 問題で指定された実行時間以内にプログラムが終了しませんでした。"
  show RE = "RE (Runtime Error) プログラムの実行中にエラーが発生しました。コンパイル時に検知できなかったエラーがあります.スタックオーバーフロー、ゼロ除算などが原因です."
  show OLE = "OLE (Output Limit Exceeded) 問題で指定された制限を超えるサイズの出力を行いました。"
  show IE = "IE (Internal Error) 内部のエラー、つまりジャッジシステムのエラーです。"
  show WA = "WA (Wrong Answer) 誤答です。提出したプログラムの出力は正しくありません。"

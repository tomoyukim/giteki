(defpackage giteki/tests/main
  (:use :cl
        :giteki
        :rove)
  (:import-from #:jonathan #:parse))
(in-package :giteki/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :giteki)' in your Lisp.

(defvar fixture "
{
  \"giteki\":[
    {
      \"gitekiInfo\": {
        \"attachmentFileKey\": \"\",
        \"name\": \"Ｒａｓｐｂｅｒｒｙ　Ｐｉ\",
        \"fqMaintainFunc\": \"無\",
        \"organName\": \"(株)ＵＬ　Ｊａｐａｎ\",
        \"attachmentFileCntForCd2\": \"\",
        \"attachmentFileCntForCd1\": \"\",
        \"spuriousRules\": \"新スプリアス規定\",
        \"date\": \"2018-05-17\",
        \"attachmentFileName\": \"\",
        \"number\": \"007-ＡＧ0046\",
        \"radioEquipmentCode\": \"第２条第１９号に規定する特定無線設備\",
        \"bodySar\": \"—\",
        \"elecWave\": \"Ｇ１Ｄ　2412〜2462ＭＨz（５ＭＨz間隔11波）　0.003210Ｗ／ＭＨz\\nＧ１Ｄ，Ｄ１Ｄ　2412〜2462ＭＨz（５ＭＨz間隔11波）　0.005126，0.005327Ｗ／ＭＨz\\nＧ１Ｄ，Ｄ１Ｄ　2422〜2452ＭＨz（５ＭＨz間隔７波）　0.002432Ｗ／ＭＨz\\nＦ１Ｄ　2402〜2480ＭＨz（1000kＨz間隔79波）　0.000218〜0.000805Ｗ／ＭＨz\\nＧ１Ｄ　2402〜2480ＭＨz（1000kＨz間隔79波）　0.000180〜0.000660Ｗ／ＭＨz\\nＦ１Ｄ　2402〜2480ＭＨz（2000kＨz間隔40波）　0.007234Ｗ\",
        \"note\": \"変更履歴は次のとおり。\\n・2019年12月19日に下記のとおり変更\\n【氏名又は名称】ＲＡＳＰＢＥＲＲＹ　ＰＩ　（ＴＲＡＤＩＮＧ）　ＬＩＭＩＴＥＤ\",
        \"typeName\": \"Ｒａｓｐｂｅｒｒｙ　Ｐｉ　３　Ｍｏｄｅｌ　Ｂ＋\",
        \"techCode\": \"登録証明機関による工事設計認証\",
        \"no\": \"1\"
      }
    }
  ],
  \"gitekiInformation\":{
    \"totalCount\":\"0\",
    \"lastUpdateDate\":\"2022-12-28\"
  }
}
")

(deftest json-get-test
  (testing ""
    (let ((json (parse "{\"no\":\"1\"}")))
      (ok (expands '(giteki:json-get json :|no|)
                   `(reduce #'getf (list json :|no|)))))))

(deftest total-count-test
  (testing "should return totalCount property in the response"
    (let ((json (parse "{\"gitekiInformation\":{\"totalCount\":\"10\",\"lastUpdateDate\":\"2022-12-28\"}}")))
      (ok (eql (giteki:total-count json) 10))))
  (testing "should return 0 when the response doesn't have totalCount unexpectedly"
    (let ((json (parse "{\"gitekiInformation\":{\"lastUpdateDate\":\"2022-12-28\"}}")))
      (ok (eql (giteki:total-count json) 0)))))

(deftest giteki-list-test
  (testing "should return giteki list in the response"
    (let* ((json (parse fixture))
           (glist (giteki:giteki-list json))
           (ginfo (getf (first glist) :|gitekiInfo|)))
      (ok (eql (parse-integer (getf ginfo :|no|)) 1)))))

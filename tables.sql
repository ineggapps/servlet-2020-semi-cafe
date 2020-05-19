-- 회원

CREATE TABLE member(
    userNum NUMBER, --회원번호 (기본키)
    email VARCHAR2(50) NOT NULL, -- 이메일
    userId VARCHAR2(50) NOT NULL, -- 아이디
    userPwd VARCHAR2(200) NOT NULL, -- 비밀번호
    userName VARCHAR2(50) NOT NULL,  -- 이름
    nickname VARCHAR2(50), -- 별명 (OOO님 커피 나왔습니다~)
    created_date DATE DEFAULT SYSDATE, -- 가입일시
    updated_date DATE DEFAULT SYSDATE, -- 회원정보 수정일시
    phone VARCHAR2(50), -- 휴대폰번호
    enabled NUMBER(1) DEFAULT 1, -- 회원탈퇴여부 (0: 탈퇴, 1:회원(기본값))
    CONSTRAINT pk_member_userNum PRIMARY KEY(userNum)
    CONSTRAINT uk_member_userId UNIQUE(userId),
    CONSTRAINT uk_member_email UNIQUE(email),
    CONSTRAINT uk_member_phone UNIQUE(phone)
);

CREATE TABLE member_admin(
    userNum NUMBER,
    CONSTRAINT pk_admin_userNum PRIMARY KEY (adminNum),
    CONSTRAINT fk_admin_userNum FOREIGN KEY(adminNum) REFERENCES member(userNum)
);

CREATE SEQUENCE member_seq -- 회원번호 시퀀스 
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

-- 공지사항

CREATE TABLE notice(
    num NUMBER, -- 게시글 번호(기본키)
    userNum NUMBER NOT NULL, -- 작성자 회원번호
    subject VARCHAR2(255) NOT NULL, -- 제목
    content VARCHAR2(4000) NOT NULL, -- 내용
    views NUMBER DEFAULT 0, -- 조회수
    created_date DATE DEFAULT SYSDATE, -- 게시글 작성일시
    updated_date DATE DEFAULT SYSDATE, -- 게시글 수정일시
    CONSTRAINT pk_notice_num PRIMARY KEY(num), 
    CONSTRAINT fk_notice_userNum FOREIGN KEY(userNum) REFERENCES member(userNum)
);

CREATE SEQUENCE notice_seq -- 게시글번호 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

-- 이벤트

CREATE TABLE event(
    num NUMBER, -- 이벤트 게시글번호 (기본키)
    userNum NUMBER NOT NULL, -- 작성자 회원번호
    subject VARCHAR2(255) NOT NULL, -- 제목
    content VARCHAR2(4000) NOT NULL, -- 내용
    views NUMBER DEFAULT 0, -- 조회수
    start_date DATE NOT NULL, -- 이벤트 시작일자
    end_date DATE NOT NULL, -- 이벤트 종료일자
    created_date DATE DEFAULT SYSDATE, -- 게시글 작성일시
    updated_date DATE DEFAULT SYSDATE, -- 게시글 수정일시
    CONSTRAINT pk_event_num PRIMARY KEY(num),
    CONSTRAINT fk_event_userNum FOREIGN KEY(userNum) REFERENCES member(userNum)
);

CREATE SEQUENCE event_seq -- 이벤트 게시글 일련번호
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

-------------
-- 메뉴 구분

CREATE TABLE menu_category(
    categoryNum NUMBER, -- 메뉴 카테고리 구분자 (기본키) (1: 커피, 2: 에이드, 3: 베이커리)
    categoryName VARCHAR2(255), -- 메뉴이름 (커피, 에이드, 베이커리)
    CONSTRAINT pk_menu_category PRIMARY KEY(categoryNum)
);

CREATE SEQUENCE menu_category_seq --메뉴 카테고리 구분자 일련번호
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;


CREATE TABLE menu( 
    menuNum NUMBER, -- 메뉴 일련번호 (1: 아메리카노, 2: 크루아상 3: 카페모카 ...)
    categoryNum NUMBER NOT NULL, -- 메뉴 카테고리 구분자
    menuName VARCHAR2(255) NOT NULL, -- 메뉴이름 (아메리카노, 크루아상, 카페모카 ...)
    thumbnail VARCHAR2(500),
    text VARCHAR2(4000) NOT NULL, -- 메뉴 소개글
    price NUMBER DEFAULT 0, -- 가격 (구매 시 필요)
    CONSTRAINT pk_menu_num PRIMARY KEY(menuNum),
    CONSTRAINT fk_menu_category FOREIGN KEY(categoryNum) REFERENCES menu_category(categoryNum)
);

CREATE SEQUENCE menu_seq -- 메뉴 일련번호 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;


----------------
-- 매장 정보

CREATE TABLE store(
    storeNum NUMBER, -- 매장일련번호
    storeName VARCHAR2(200), --매장 이름
    tel VARCHAR2(50),
    storeAddress VARCHAR2(500), -- 매장 주소
    visible NUMBER(1) DEFAULT 1, -- 0(목록에서 안 보임), 1(보임)
    CONSTRAINT pk_store_num PRIMARY KEY (storeNum)
);

CREATE SEQUENCE store_seq -- 매장 일련번호 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;


----------------
--주문과 주문 상세

CREATE TABLE order_status(
    statusNum NUMBER, -- 1: 결제완료, 2: 제조대기, 3: 제조 중, 4: 제조 완료
    statusName VARCHAR2(100),
    CONSTRAINT pk_status_num PRIMARY KEY(statusNum)
);

CREATE SEQUENCE order_status_seq -- 주문 상태번호
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;


CREATE TABLE order_history(
    orderNum NUMBER,
    totalPaymentAmount NUMBER NOT NULL, --최종 결제금액
    storeNum NUMBER NOT NULL, --주문 매장번호
    statusNum NUMBER NOT NULL,
    userNum NUMBER,
    cardNum NUMBER, -- ALTER TABLE로 제약사항 추가하기
    order_date DATE DEFAULT SYSDATE, --주문일시
    cancelNum NUMBER, -- ALTER TABLE로 제약사항 추가하기
    CONSTRAINT pk_order_history_num PRIMARY KEY(orderNum),
    CONSTRAINT fk_order_history_userNum FOREIGN KEY(userNum) REFERENCES member(userNum) 
-- CONSTRAINT fk_cancel_num FOREIGN KEY(cancelNum) REFERENCES order_cancel(cancelNum)
-- CONSTRAINT fk_cards_num FOREIGN KEY(cardNum) REFERENCES cards(cardNum)
);

CREATE SEQUENCE order_history_seq -- 주문 일련번호 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

CREATE TABLE order_cancel(
    cancelNum NUMBER,
    orderNum NUMBER,
    paymentAmount NUMBER,
    canceled_date DATE DEFAULT SYSDATE,
    CONSTRAINT pk_cancel_num PRIMARY KEY(cancelNum),
    CONSTRAINT fk_order_cancel_num FOREIGN KEY(orderNum) REFERENCES order_history(orderNum)
);

CREATE SEQUENCE order_cancel_seq -- 주문 취소
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

-- 결제 버튼 누를 때 DB에 입력
-- 결제 이전에는 세션에 List<>를 만들어 두고 활용하는 것이 좋을 듯!
CREATE TABLE order_detail(
    detailNum NUMBER, --주문상세일련번호
    orderNum NUMBER,
    unitPrice NUMBER NOT NULL, -- 단가
    quantity NUMBER NOT NULL, -- 수량
    paymentAmount NUMBER NOT NULL, -- 결제금액 (할인 등 변수 고려)
    CONSTRAINT pk_order_detail_num PRIMARY KEY(detailNum),
    CONSTRAINT fk_order_detail_num FOREIGN KEY(orderNum) REFERENCES order_history(orderNum)
);

CREATE SEQUENCE order_detail_seq -- 주문 일련번호 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

-- 카드 보유내역
-- 카드 보유현황

CREATE TABLE card_model(
    modelNum NUMBER,
    modelName VARCHAR2(100) NOT NULL,
    text VARCHAR2(4000) NOT NULL ,
    thumbnail VARCHAR2(500),
    CONSTRAINT pk_model_num PRIMARY KEY(modelNum)
);

CREATE SEQUENCE card_model_seq -- 카드 모델(종류) 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;


CREATE TABLE cards(
    cardNum NUMBER,
    cardName VARCHAR2(255),
    userNum NUMBER NOT NULL,
    modelNum NUMBER NOT NULL,
    cardIdentity VARCHAR2(16), -- 16자리 하이픈없이 숫자만
    balance NUMBER DEFAULT 0,
    CONSTRAINT pk_cards_num PRIMARY KEY(cardNum),
    CONSTRAINT uk_cards_identity UNIQUE(cardIdentity),
    CONSTRAINT fk_model_num FOREIGN KEY(modelNum) REFERENCES card_model(modelNum)
);

CREATE SEQUENCE cards_seq -- 카드 일련번호 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

CREATE TABLE card_charge(--카드 충전내역
    chargeNum NUMBER,
    cardNum NUMBER NOT NULL,
    chargeAmount NUMBER NOT NULL,
    charge_date DATE DEFAULT SYSDATE,
    CONSTRAINT pk_card_charge_num PRIMARY KEY(chargeNum),
    CONSTRAINT fk_card_charge_cardNum FOREIGN KEY(cardNum) REFERENCES cards(cardNum)
);

CREATE SEQUENCE card_charge_seq -- 카드충전내역 시퀀스
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;




---제약사항 추가
ALTER TABLE order_history ADD CONSTRAINT fk_cancel_num FOREIGN KEY(cancelNum) REFERENCES order_cancel(cancelNum);
ALTER TABLE order_history ADD CONSTRAINT fk_cards_num FOREIGN KEY(cardNum) REFERENCES cards(cardNum);



--테이블 삭제
ALTER TABLE order_history DROP CONSTRAINT fk_cancel_num;
ALTER TABLE order_history DROP CONSTRAINT fk_cards_num;
DROP TABLE NOTICE PURGE;
DROP SEQUENCE NOTICE_SEQ;
DROP TABLE EVENT PURGE;
DROP SEQUENCE EVENT_SEQ;
DROP TABLE MENU PURGE;
DROP SEQUENCE MENU_SEQ;
DROP TABLE MENU_CATEGORY PURGE;
DROP SEQUENCE MENU_CATEGORY_SEQ;
DROP TABLE STORE PURGE;
DROP SEQUENCE  STORE_SEQ;
DROP TABLE ORDER_STATUS PURGE;
DROP SEQUENCE  ORDER_STATUS_SEQ;
DROP TABLE ORDER_CANCEL PURGE;
DROP SEQUENCE ORDER_CANCEL_SEQ;
DROP TABLE ORDER_DETAIL PURGE;
DROP SEQUENCE ORDER_DETAIL_SEQ;
DROP TABLE ORDER_HISTORY PURGE;
DROP SEQUENCE ORDER_HISTORY_SEQ;
DROP TABLE CARDS PURGE;
DROP SEQUENCE CARDS_SEQ;
DROP TABLE CARD_MODEL PURGE;
DROP SEQUENCE CARD_MODEL_SEQ;
DROP TABLE MEMBER PURGE;
DROP SEQUENCE MEMBER_SEQ;


SELECT * FROM TAB;
SELECT * FROM SEQ;


-- 카드모델 샘플 데이터

INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '열정응원카드', '당신의 열정을 응원합니다', '/resource/images/members/card/card01.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '쿠앤크레몬카드', '레몬처럼 상큼한 쿠앤크카드', '/resource/images/members/card/card02.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '마음에 싹트다 카드', '쓸수록 마음이 싹트는 카드', '/resource/images/members/card/card03.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '오렌지 카드', '오렌지가 가득한 새콤한 쿠앤크카드', '/resource/images/members/card/card04.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '레드 카드', '레드레드한 쿠앤크카드', '/resource/images/members/card/card05.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '스튜던트 카드', '초심으로 돌아가 연필을 잡자 카드', '/resource/images/members/card/card06.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '나는야 백조카드', '핑크핑크한 백조를 보셨나요?', '/resource/images/members/card/card07.png');
INSERT INTO card_model(modelNum, modelName, text, thumbnail) VALUES(card_model_seq.NEXTVAL, '네추럴 카드', '로이더 아니고 네추럴 카드', '/resource/images/members/card/card08.png');
COMMIT;

-- 메뉴 카테고리 샘플

INSERT INTO MENU_CATEGORY(categoryNum, categoryName) VALUES(menu_category_seq.NEXTVAL, '커피');
INSERT INTO MENU_CATEGORY(categoryNum, categoryName) VALUES(menu_category_seq.NEXTVAL, '에이드');
INSERT INTO MENU_CATEGORY(categoryNum, categoryName) VALUES(menu_category_seq.NEXTVAL, '베이커리');
INSERT INTO MENU_CATEGORY(categoryNum, categoryName) VALUES(menu_category_seq.NEXTVAL, '기타');
COMMIT;

-- 지점

INSERT INTO store(storeNum, storeName, TEL, storeAddress, visible) VALUES(store_seq.NEXTVAL, '온라인', '1588-0000', '온라인 구매', 0);
INSERT INTO store(storeNum, storeName, TEL, storeAddress) VALUES(store_seq.NEXTVAL, '온라인', '1588-0000', '서울특별시 마포구 서교동 10-1');
COMMIT;


--카드 충전 포인트 샘플 데이터
INSERT INTO card_charge(chargeNum, cardNum, chargeAmount) VALUES(card_charge_seq.NEXTVAL, 1, 10000);
COMMIT;
----카드 충전 포인트 트리거

--포인트 충전 내역 등록/수정/삭제 트리거

--포인트 충전 시
CREATE OR REPLACE TRIGGER ins_card_charge_point
AFTER INSERT ON card_charge
FOR EACH ROW

BEGIN
     UPDATE cards SET balance = balance + :NEW.chargeAmount
           WHERE cardNum = :NEW.cardNum;
END;
/

-- 포인트 충전내역 수정 시 (기능 중 포인트 충전내역을 수정할 일은 없게 할 것이지만 혹시 몰라서 삽입)
CREATE OR REPLACE TRIGGER update_card_charge_point
AFTER UPDATE ON card_charge
FOR EACH ROW
BEGIN
     UPDATE cards SET balance = balance - :OLD.chargeAmount + :NEW.chargeAmount
            WHERE cardNum = :NEW.cardNum;
END;
/

-- 포인트 충전내역 삭제 시
CREATE OR REPLACE TRIGGER delete_card_charge_point
AFTER DELETE ON card_charge
FOR EACH ROW
BEGIN
     UPDATE cards SET balance = balance - :OLD.chargeAmount;
           WHERE cardNum = :OLD.cardNum;
END;
/

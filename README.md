🥊 파일구조 대략적인 설명
src
 - API(back) => http 통신하는 파일( node js와 통신)
 - Binding(back) => bindingbuilder를 사용하지않고 class로 따로 빼서 관리하는파일
 - Controller(back) => 상태관리(값이변하는것들) 하는 파일(GETX)
 - Static => 정적 파일들 font,color,url,widget(따로뺄예정) ...등등 
 - View(front) => auth(회원가입..로그인..관련한것들) Nav(로그인이후에화면)
 - main =>  라우터관리

🥊 기능(요구사항 명세서)  
 🧠LOADING   
   - 위치정보 받아오기   
   - 자동로그인기능   
    sharedPreferences에 userid 저장되어있다면 navigation 페이지로 이동   
    sharedPreferences에 userid 저장되어있지않다면 login 페이지로 이동    
    
 🧠AUTH(회원에 관한기능)   
   - 로그인    
    회원가입이 되어있는경우 (SNS EMAIL로 CHECK) 즉 로그아웃한 경우(DB에 USER EMAIL있는경우)   
       agreement page에서 userid와 token값 받아 sharedPreferences에 저장   
       다시 회원가입을 하지않고 navigation 페이지로 이동   
    
   - 회원가입   
    회원가입이 되어있지 않는 경우   
       회원가입페이지로 이동   
        회원가입은 반드시 모든필드를 입력하거나 , 건너뛰기를 하여야만 회원가입가능   
        회원가입 완료후 register page에서 userid와 token 값 받아 sharedPreferences에 저장후 navigation 페이지로 이동   
 
   - 회원탈퇴   
    DB에서 USER에 관한 정보 DELETE!! ( USER와 PK관계인 것들도 삭제해야함..EX) 즐겨찾기..좋아요..댓글등등!)   
      sharedPreferences에 저장된 USER정보 삭제   
   - 로그아웃   
      sharedPreferences에 저장된 USER정보 삭제   
  
   - 회원정보 업데이트   
     usermodify 페이지에서 반드시 모든필드를 입력후 확인버튼 누를시 DB UPDATE!   

  🧠NAVIGATION(어플리케이션 기능)
 
  



🥊 목표할것 

 - GETX를 통해 비즈니스로직과 화면을 분리할것 
 - 소스코드 재사용이 가능하도록 할 것
 - 좋은 소스코드 유튜브에서 참고할 것
 - 규칙에 맞게 코딩할것!!(클래스이름 대문자!)
 - 기능업데이트 할때마다 README 파일 수정하기,,,,
 - 배포전 각 dart파일에 관한 정리 필요
 
 
 
 

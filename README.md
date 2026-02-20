# Modified AES128 Decryptor Design
> **System Semiconductor Design Project - Advanced Encryption Standard**

본 프로젝트는 **Modelsim 및 Synopsys Design Compiler**를 활용하여 고성능 **Modified AES128 Decryptor**를 설계하고 최적화하는 것을 목표로 한다. 주어진 암호문(Ciphertext)을 복호화하고, 하드웨어 타이밍(Slack) 성능을 극대화하는 데 초점을 맞추었다.

---

## 📌 Project Overview
주어진 SBOX, KeyScheduler 단 2개의 모듈을 기반으로 AES128 복호화 알고리즘의 전체 프로세스를 구현하였다. 특히 하드웨어 합성(Synthesis) 단계에서 타이밍 제약 조건을 최적화하여 연산 속도를 크게 향상시켰습니다.

* **Target Board**: Xilinx Zynq UltraScale+ (ZCU104 기반 설정)
* **Design Focus**: Timing Optimization (Slack Maximization)
* **Key Components**: InvSBOX, InvMixColumns, InvShiftRows, AddRoundKey, InvKeyScheduler

---

## ⚡ Performance Optimization (Slack Improvement)
본 설계의 가장 큰 성과는 하드웨어 로직 최적화를 통해 **타이밍 슬랙(Slack)을 획기적으로 개선**한 점이다. Legacy Design 또한 Pipeline구조를 적용하여 최대한 Slack을 높여 제작한 초기 모듈이지만, 이후 추가적인 Flattening 및 모듈을 합치고 개선하여 Slack에 추가적인 향상을 이루어냈다.

* **Constraints**: Clock Period = **10.0 ns**
* **Legacy Design**: Slack **9.51 ns** (Actual Delay: 0.49 ns)
* **Optimized Design**: Slack **9.66 ns** (Actual Delay: 0.34 ns)
* **Result**: 로직 경로 최적화를 통해 실제 지연 시간(Delay)을 **0.49ns에서 0.34ns로 약 30.6% 단축**하여 하드웨어 안정성과 동작 속도를 확보하였습니다.



---

## 📖 Technical Details

### 1. AES128 Decryption Flow
1. **Initial Round**: AddRoundKey
2. **Main Rounds (1-9)**: InvShiftRows → InvSubBytes → AddRoundKey → InvMixColumns
3. **Final Round**: InvShiftRows → InvSubBytes → AddRoundKey

### 2. Implementation Strategies
* **Parallel Processing**: 복호화 연산의 병렬성을 활용하여 데이터 처리 효율 증대.
* **InvKeyScheduler**: 128비트 키를 역순으로 확장하여 각 라운드에 동기화된 라운드 키 공급.
* **Logic Synthesis**: 타이밍 크리티컬 패스(Critical Path)를 분석하여 조합 회로의 깊이를 최소화.

---

## 📂 Directory Structure
### 0. `legacy/` - Verilog Source Codes
복호화 로직을 기반으로 제작한 초기 모델로, 주어진 단 2개의 모듈, SBOX, KeyScheduler를 활용하여 역설계한 모듈입니다. Pipeline 구조를 적용하여 Slack에 있어 유리하지만, 완전히 최적화가 되어있지는 않습니다.

### 1. `rtl/` - Verilog Source Codes
Slack에 있어 최적화를 하기위하여, Flattening 및 legacy 대비 일부 모듈을 합쳤으며, reset 및 신호들을 동기화하였습니다. 이를 통해 Slack 부문에서 최적화된 복호화 로직의 핵심 설계 파일들이 포함되어 있습니다.
* **`TOPpipelined_revision.v`**: 파이프라인 기술이 적용된 최상위 복호화 모듈.
* **`Round1to10_revision.v`**: AES 복호화의 1~10 라운드 로직을 제어하는 핵심 모듈.
* **`InvSubBytes_revision.v`**: 수정된 버전의 Inverse SubBytes 레이어.
* **`InvSBOX_Pipe.v`**: 타이밍 최적화를 위해 파이프라인 구조로 설계된 Inverse S-Box.
* **`InvMixColumns.v`**: 역방향 믹스 컬럼 연산 로직.
* **`InvShiftRows.v`**: 역방향 쉬프트 로우 연산 로직.
* **`AddRoundKey.v`**: 데이터와 라운드 키의 XOR 연산 수행.
* **`InvKeyScheduler.v`**: 복호화 프로세스에 필요한 라운드 키를 역순으로 생성.
* **`KeySaving.v` / `KeyScheduler.v`**: 초기 키 확장 및 저장을 위한 서브 모듈.
* **`tb_TOP_revision.v`**: 전체 디자인의 정밀 검증을 위한 테스트벤치.
* **`SBS_Verification.py`**: 시뮬레이션 결과 검증을 위한 Python 스크립트.

### 2. `outputs/` - Synthesis Outputs
EDA Tool(Design Compiler)을 거쳐 생성된 결과물입니다.
* **`TOP_mapped.v`**: 하드웨어 라이브러리로 매핑된 최종 Netlist 파일.

### 3. `reports/` - Analysis Reports
합성 후 하드웨어 성능 지표를 분석한 리포트입니다.
* **`TOP_mapped.timing.rpt`**: 타이밍 분석 결과 리포트 (최종 Slack 9.66ns 달성 기록).
* **`TOP_mapped.area.rpt`**: 전체 게이트 수 및 면적(Area) 분석 리포트.

---

## 📊 Verification & Results
* **Functional Verification**: 주어진 128비트 Ciphertext에 대해 정해진 Key 값을 사용하여 원래의 Plaintext로 정확히 복호화되는 것을 시뮬레이션을 통해 검증 완료.
* **Synthesis Result**: 목표 Specification을 상회하는 Slack을 달성한 Slack 성능 기반 하드웨어 설계를 완료하였습니다.

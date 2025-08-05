# Tragedy NFT Viewer & Developer Tools

Tragedy NFTシステムのビューアと開発ツールです。

## ツール

### 1. NFT Viewer (`index.html`)
- 全てのミントされたNFTを表示
- 特定のウォレットアドレスが所有するNFTを表示
- トークンIDで特定のNFTを表示
- SVGの直接表示
- 属性（Species、Background、Item、Effect）の表示
- オーナーアドレスの表示

### 2. Developer Tools (`dev-tools.html`)
- **NFT Viewer**: 個別のNFTデータとSVGを確認
- **Composer Test**: 任意の組み合わせでSVGを合成してテスト
- **Material Banks**: 各バンク（Monster、Background、Item、Effect）の個別SVGを確認
- **Metadata**: 各属性の名前（英語/日本語）を確認
- **Contract Info**: デプロイされた全コントラクトのアドレスと統計情報

## 使い方

### ローカルで実行

1. Python 3がインストールされている場合：
```bash
cd viewer
python3 -m http.server 8000
```

2. Node.jsがインストールされている場合：
```bash
cd viewer
npx http-server -p 8000
```

3. ブラウザで `http://localhost:8000` を開く

### 機能の使用方法

- **View All NFTs**: 全てのミントされたNFTを表示
- **View Wallet**: ウォレットアドレスを入力して、そのウォレットが所有するNFTを表示
- **View Single NFT**: トークンIDを入力して、特定のNFTを表示

## 技術仕様

- **使用ライブラリ**: ethers.js v5.7.2 (CDN経由)
- **ネットワーク**: Bon-Soleil (RPC: https://dev2.bon-soleil.com/rpc)
- **NFTコントラクト**: 0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0

## カスタマイズ

`viewer.js`の以下の定数を変更することで、別のネットワークやコントラクトに対応できます：

```javascript
const NFT_ADDRESS = "0x79BA8659feF8A0792A3EDD0E27e885e72eFbc9B0";
const RPC_URL = "https://dev2.bon-soleil.com/rpc";
```